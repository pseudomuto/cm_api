# frozen_string_literal: true
module CMAPI
  # The main entry point for this gem. The client represents a single "session" with the API.
  #
  # @example
  #   api      = CMAPI::Client.new(host: "YOUR_HOST")
  #   resource = api.echo("test message")
  #
  #   resource.message #=> "test message"
  #
  # @example supplying custom user, pass and version
  #   api      = CMAPI::Client.new(host: "YOUR_HOST", user: "admin", pass: "admin", version: "v13")
  #   resource = api.echo("test message")
  #
  #   resource.message #=> "test message"
  #
  # @example using HTTPS on a custom port
  #   api       = CMAPI::Client.new(host: "YOUR_HOST", user: "admin", pass: "admin", version: "v13")
  #   api.https = true
  #   api.port  = 7183
  #
  #   resource = api.echo("test message")
  #   resource.message #=> "test message"
  class Client
    DEFAULT_USER    = "admin"
    DEFAULT_PASS    = "admin"
    DEFAULT_PORT    = 7180
    DEFAULT_VERSION = 13

    using Refinements

    require "cm_api/client/clusters"
    require "cm_api/client/tools"
    require "cm_api/client/users"

    include Clusters
    include Tools
    include Users

    # @return [String] the API host name
    attr_reader :host

    # @return [Integer] the API version
    attr_reader :version

    # @return [Integer] the API port
    attr_accessor :port

    # @return [Boolean] whether or not to use https
    attr_accessor :https

    # Provides access to the last API response.
    # @return [Faraday::Response, nil] the response from the last request (if any)
    attr_reader :last_response

    # Initialize a new API client.
    # @raise [InvalidHostError] when the host name is invalid
    #
    # @param host [String] the hostname (without the port)
    # @param user [String] the user to connect as
    # @param pass [String] the password for the user
    # @param version [String] the API version to use
    def initialize(host:, user: DEFAULT_USER, pass: DEFAULT_PASS, version: DEFAULT_VERSION)
      @host = host
      raise InvalidHostError, "'#{host}' is not a valid host" unless valid_host?

      @port    = DEFAULT_PORT
      @user    = user
      @pass    = pass
      @version = version
    end

    # Make a GET request to the API.
    #
    # @param path [String] the path to the resource (not including /api/{version})
    # @param params [Hash] query string parameters to be passed
    # @return [Resource,Error] the deleted resource parsed from the response or an {Error}
    #
    # @example
    #   client   = CMAPI::Client.new(host: "myhost.com")
    #   resource = client.get("/tools/echoError", message: "my error message")
    #
    #   # fetched http://myhost.com:7180/api/v13/tools/echoError?message=my%20error%20message
    #   resource.message #=> "my error message"
    def get(path, **params)
      @last_response = connection.get(normalize_path(path), params)
      parsed_response
    end

    # Make a POST request to the API.
    #
    # @param path [String] the path to the resource (not including /api/{version})
    # @param body [Hash] the optional request body to send
    # @return [Resource,Error] the deleted resource parsed from the response or an {Error}
    #
    # @example
    #   client = CMAPI::Client.new(host: "myhost.com")
    #   resource = client.post("/clusters", body: { name: "New Cluster", full_version: "5.8.1" })
    #
    #   resource.name #=> "New Cluster"
    def post(path, body: nil)
      body ||= {}

      @last_response = connection.post(normalize_path(path), JSON.generate(body))
      parsed_response
    end

    # Make a PUT request to the API.
    #
    # @param path [String] the path to the resource (not including /api/{version})
    # @param body [Hash] the optional request body to send
    # @return [Resource,Error] the parsed resource from the response or an {Error}
    #
    # @example
    #   client = CMAPI::Client.new(host: "myhost.com")
    #   resource = client.put("/clusters/New+Cluster", body: { name: "Newer Cluster"})
    #
    #   resource.name #=> "Newer Cluster"
    def put(path, body: nil)
      body ||= {}

      @last_response = connection.put(normalize_path(path), JSON.generate(body))
      parsed_response
    end

    # Make a DELETE request to the API.
    #
    # @param path [String] the path to the resource (not including /api/{version})
    # @param params [Hash] query string parameters to be passed
    # @return [Resource,Error] the deleted resource parsed from the response or an {Error}
    #
    # @example
    #   client = CMAPI::Client.new(host: "myhost.com")
    #   resource = client.delete("/clusters/someCluster")
    #
    #   resource.name #=> "someCluster"
    def delete(path, **params)
      @last_response = connection.delete(normalize_path(path), params)
      parsed_response
    end

    private

    def connection
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request(:basic_auth, @user, @pass)
        conn.request(:cmapi_request)
        conn.response(:cmapi_response, self)
        conn.adapter(Faraday.default_adapter)
      end
    end

    def normalize_path(path)
      path = "/#{path}" unless path.start_with?("/")
      URI.encode("/api/v#{version}#{path}")
    end

    def base_url
      @base_url ||= begin
        scheme = secure? ? "https" : "http"
        "#{scheme}://#{host}:#{port}"
      end
    end

    def valid_host?
      @host&.strip.present?
    end

    def secure?
      !!https
    end

    def enforce_min_version!(api_version)
      raise UnsupportedVersionError, "Only versions >= #{api_version} are supported." unless version >= api_version
    end

    def parsed_response
      return Error.new(@last_response) unless @last_response.status / 100 == 2
      @last_response.body
    end
  end
end
