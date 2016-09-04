# frozen_string_literal: true
module CMAPI
  # A class representing an API error.
  class Error
    # @return [Integer] the status code of the response
    attr_reader :status

    # @return [String] the error message returned from response
    attr_reader :message

    # Initializes a new Error
    #
    # @param response [Faraday::Response] the response from the API call
    def initialize(response)
      @message = response.body.message
      @status  = response.status
    end
  end
end
