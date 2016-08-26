# frozen_string_literal: true
module CMAPI
  class Client
    using Refinements

    DEFAULT_PORT        = 7180
    DEFAULT_SECURE_PORT = 7183

    attr_reader :host, :port, :version
    attr_reader :last_response

    def initialize(host:, port: nil, version: "v13", secure: false)
      @host = host
      raise InvalidHostError, "'#{host}' is not a valid host" unless valid_host?

      @port    = port
      @port    = (secure ? DEFAULT_SECURE_PORT : DEFAULT_PORT) if port.nil?
      @version = version
      @secure  = secure
    end

    def get(path, **params)
      @last_response = connection.get(normalize_path(path), params)
      @last_response.body
    end

    private

    def connection
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request(:cmapi_request)
        conn.response(:cmapi_response)
        conn.adapter(Faraday.default_adapter)
      end
    end

    def normalize_path(path)
      path = "/#{path}" unless path.start_with?("/")
      "/api/#{version}#{path}"
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
      !!@secure
    end
  end
end
