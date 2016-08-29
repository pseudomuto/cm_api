# frozen_string_literal: true
module CMAPI
  module Middleware
    # Response middleware for converting a response body into a {Resource}
    class Response < Faraday::Response::Middleware
      # Parse the response into a {Resource} object
      #
      # @param response [String] the response body
      # @return [Resource] the parsed resource
      def parse(response)
        json = JSON.parse(response)
        Resource.new(json)
      end
    end
  end
end
