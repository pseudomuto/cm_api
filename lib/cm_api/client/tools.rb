# frozen_string_literal: true
module CMAPI
  class Client
    # API endpoints within /tools
    module Tools
      # Echoes the give message
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__tools_echo.html
      #
      # @param message [String]
      # @return [Resource] the original message
      def echo(message:)
        get("/tools/echo", message: message)
      end

      # Echoes the given message as an error
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__tools_echoError.html
      #
      # @param message [String] the message to echo
      # @return [Resource] the original message and list of causes
      def echo_error(message:)
        get("/tools/echoError", message: message)
      end
    end
  end
end
