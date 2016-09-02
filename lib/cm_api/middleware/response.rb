# frozen_string_literal: true
module CMAPI
  module Middleware
    # Response middleware for converting a response body into a {Resources::Base}
    class Response < Faraday::Response::Middleware
      # @return [Client] the api client that initiated the request
      attr_reader :api_client

      # Initializes this response middleware.
      #
      # @param api_client [Client] the client that initiated the request
      def initialize(app, api_client)
        super(app)
        @api_client = api_client
      end

      # Parse the response into a {Resources::Base} object(s)
      #
      # @param response [String] the response body
      # @return [Resources::Base, Array<Resources::Base>] the parsed resource(s)
      #
      # @note when the response contains a single top-level item named "items", each resource will be parsed and an
      # array will be returned.
      def parse(response)
        json = JSON.parse(response)
        array_response?(json) ? json["items"].map(&method(:create_resource)) : create_resource(json)
      end

      private

      def create_resource(item)
        item.is_a?(Hash) ? Resources::Base.new(item, api_client: api_client) : item
      end

      def array_response?(json)
        json.size == 1 && json.key?("items")
      end
    end
  end
end
