# frozen_string_literal: true
module CMAPI
  module Middleware
    class Request < Faraday::Middleware
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(request)
        headers = request.fetch(:request_headers)
        headers["Content-Type"] = "application/json"

        @app.call(request)
      end
    end
  end
end
