# frozen_string_literal: true
module CMAPI
  class Client
    module Tools
      def echo(message:)
        get("/tools/echo", message: message)
      end

      def echo_error(message:)
        get("/tools/echoError", message: message)
      end
    end
  end
end
