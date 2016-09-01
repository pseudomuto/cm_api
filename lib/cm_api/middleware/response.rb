# frozen_string_literal: true
module CMAPI
  module Middleware
    # Response middleware for converting a response body into a {Resources::Base}
    class Response < Faraday::Response::Middleware
      # Parse the response into a {Resources::Base} object
      #
      # @param response [String] the response body
      # @return [Resources::Base] the parsed resource
      def parse(response)
        json = JSON.parse(response)
        Resources::Base.new(json)
      end
    end
  end
end
