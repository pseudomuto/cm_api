# frozen_string_literal: true
require "faraday"

module CMAPI
  InvalidHostError = Class.new(StandardError)

  autoload :VERSION, "cm_api/version"
  autoload :Client, "cm_api/client"
  autoload :Middleware, "cm_api/middleware"
  autoload :Refinements, "cm_api/refinements"
  autoload :Resource, "cm_api/resource"

  Faraday::Request.register_middleware(cm_api_request: -> { Middleware::Request })
end
