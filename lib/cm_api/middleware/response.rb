# frozen_string_literal: true
module CMAPI
  module Middleware
    # Response middleware for converting a response body into a {Resources::Base}
    class Response < Faraday::Response::Middleware
      # Parse the response into a {Resources::Base} object(s)
      #
      # @param response [String] the response body
      # @return [Resources::Base, Array<Resources::Base>] the parsed resource(s)
      #
      # @note when the response contains a single top-level item named "items", each resource will be parsed and an
      # array will be returned.
      def parse(response)
        json = JSON.parse(response)
        return Resources::Base.new(json) unless array_response?(json)

        json["items"].map(&method(:create_resource))
      end

      private

      def create_resource(item)
        item.is_a?(Hash) ? Resources::Base.new(item) : item
      end

      def array_response?(json)
        json.size == 1 && json.key?("items")
      end
    end
  end
end
