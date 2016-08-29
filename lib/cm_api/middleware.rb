# frozen_string_literal: true
module CMAPI
  # A module for custom request/response middleware
  module Middleware
    autoload :Request, "cm_api/middleware/request"
    autoload :Response, "cm_api/middleware/response"
  end
end
