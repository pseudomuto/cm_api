# frozen_string_literal: true
module CMAPI
  class Client
    module Users
      # Gets a list of CDM users
      #
      # @return [Resource] the list of users
      def users
        get("/users")
      end

      # Gets a single user
      #
      # @param username [String] the user to lookup
      # @returns [Resource] the user
      def user(username:)
        get("/users/#{username}")
      end

      # Looks up current user sessions
      #
      # @return [Resource] the currently active sessions
      def user_sessions
        get("/users/sessions")
      end
    end
  end
end
