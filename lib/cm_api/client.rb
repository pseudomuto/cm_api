# frozen_string_literal: true
module CMAPI
  class Client
    using Refinements

    DEFAULT_PORT        = 7180
    DEFAULT_SECURE_PORT = 7183

    attr_reader :host, :port

    def initialize(host:, port: nil, secure: false)
      @host = host
      raise InvalidHostError, "'#{host}' is not a valid host" unless valid_host?

      @port = port
      @port = (secure ? DEFAULT_SECURE_PORT : DEFAULT_PORT) if port.nil?
    end

    def get(url, **params)
      @last_response = connection.get(url, params)
      @last_response.body
    end

    private

    def valid_host?
      @host&.strip.present?
    end

    def connection
      @connection ||= Faraday.new(host) do |conn|
        conn.request(:cm_api_request)
        conn.adapter(Faraday.default_adapter)
      end
    end
  end
end
