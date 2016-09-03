# frozen_string_literal: true
module CMAPI
  class Client
    module Users
      using Refinements

      # Gets a list of CDM users
      #
      # @return [Resource] the list of users
      def users
        get("/users")
      end

      # Gets a single user
      #
      # @param name [String] the user to lookup
      # @returns [Resource] the user
      def user(name:)
        get("/users/#{name}")
      end

      # Creates a new user
      #
      # @param name [String] the new user's username
      # @param password [String] the user's password
      # @param roles [Array<String>] the roles that the user belongs to (default: "ROLE_USER")
      # @return [Resource] the new user
      def create_user(name:, password:, roles: [])
        body = { name: name, password: password, roles: Array(roles) }

        resource = post("/users", body: { items: [body] })
        resource.is_a?(Array) ? resource.first : resource
      end

      # Updates an existing user
      #
      # @param name [String] the user's username
      # @param password [String] the new password (pass `nil` to skip update)
      # @param roles [Array<String>] the new roles for the user (leave empty to skip update)
      # @return [Resource] the updated user
      def update_user(name:, password: nil, roles: [])
        return user(name: name) if password.blank? && roles.blank?

        body            = { name: name }
        body[:password] = password unless password.blank?
        body[:roles]    = roles unless roles.blank?

        put("/users/#{name}", body: body)
      end

      # Deletes the specified user from CDM
      #
      # @param name [String] the user to delete
      # @return [Resource] the deleted user
      def delete_user(name:)
        delete("/users/#{name}")
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
