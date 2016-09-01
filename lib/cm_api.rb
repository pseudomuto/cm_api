# frozen_string_literal: true
require "faraday"

module CMAPI
  # An error that's raised when the host is not valid
  InvalidHostError = Class.new(StandardError)

  # An error that's raised when the version of CDH is not valid
  InvalidCDHVersionError = Class.new(StandardError)

  autoload :VERSION, "cm_api/version"
  autoload :Client, "cm_api/client"
  autoload :Middleware, "cm_api/middleware"
  autoload :Refinements, "cm_api/refinements"
  autoload :Resources, "cm_api/resources"

  Faraday::Request.register_middleware(cmapi_request: -> { Middleware::Request })
  Faraday::Response.register_middleware(cmapi_response: -> { Middleware::Response })
end
