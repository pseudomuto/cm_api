# frozen_string_literal: true
module CMAPI
  module Middleware
    # A core request middleware class that sets the content type to json
    class Request < Faraday::Middleware
      # The rack application
      attr_reader :app

      # Initializes the middleware
      #
      # @param app [#call] the rack application
      def initialize(app)
        @app = app
      end

      # Executes this middleware by setting the content type header to "application/json"
      #
      # @param request [Hash] the current request env
      def call(request)
        headers = request.fetch(:request_headers)
        headers["Content-Type"] = "application/json"

        @app.call(request)
      end
    end
  end
end
