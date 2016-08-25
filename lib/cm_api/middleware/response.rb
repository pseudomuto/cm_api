# frozen_string_literal: true
module CMAPI
  module Middleware
    class Response < Faraday::Response::Middleware
      def parse(response)
        json = JSON.parse(response)
        Resource.new(json)
      end
    end
  end
end
