# frozen_string_literal: true
module CMAPI
  class Client
    module Users
      def users
        get("/users")
      end

      def user(username:)
        get("/users/#{username}")
      end

      def user_sessions
        get("/users/sessions")
      end
    end
  end
end
