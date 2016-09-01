# frozen_string_literal: true
module CMAPI
  class Client
    module Users
      # Gets a list of CDM users
      #
      # @return [Resources::Base] the list of users
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

      # Creates a new user
      #
      # @param name [String] the new user's username
      # @param password [String] the user's password
      # @param roles [Array<String>] the roles that the user belongs to (default: "ROLE_USER")
      # @return [Resources::Base] the new user
      def create_user(name:, password:, roles: [])
        body = { name: name, password: password, roles: Array(roles) }

        resource = post("/users", body: { items: [body] })
        resource.is_a?(Array) ? resource.first : resource
      end

      # Looks up current user sessions
      #
      # @return [Resources::Base] the currently active sessions
      def user_sessions
        get("/users/sessions")
      end
    end
  end
end
