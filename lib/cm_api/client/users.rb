# frozen_string_literal: true
module CMAPI
  class Client
    # Top-level /users endpoints
    module Users
      using Refinements

      # Gets a list of CDM users
      #
      # @param view [String] the view to return.
      #  Valid values are summary (default), full, full_with_health_check_explanation, export, export_redacted
      # @return [Array<User>,Error] the list of users or an error
      def users(view: "summary")
        response = get("/users", view: view)
        return response if response.is_a?(Error)

        response.map(&User.method(:new))
      end

      # Gets a single user
      #
      # @param name [String] the user to lookup
      # @returns [User,Error] the user
      def user(name:)
        user_or_error(get("/users/#{name}"))
      end

      # Creates a new user
      #
      # @param name [String] the new user's username
      # @param password [String] the user's password
      # @param roles [Array<String>] the roles that the user belongs to (default: "ROLE_USER")
      # @return [User,Error] the new user or an error
      def create_user(name:, password:, roles: [])
        body = { name: name, password: password, roles: Array(roles) }

        resource = post("/users", body: { items: [body] })
        resource.is_a?(Array) ? User.new(resource.first) : resource
      end

      # Updates an existing user
      #
      # @param name [String] the user's username
      # @param password [String] the new password (pass `nil` to skip update)
      # @param roles [Array<String>] the new roles for the user (leave empty to skip update)
      # @return [User,Error] the updated user or an error
      def update_user(name:, password: nil, roles: [])
        return user(name: name) if password.blank? && roles.blank?

        body            = { name: name }
        body[:password] = password unless password.blank?
        body[:roles]    = roles unless roles.blank?

        user_or_error(put("/users/#{name}", body: body))
      end

      # Deletes the specified user from CDM
      #
      # @param name [String] the user to delete
      # @return [User,Error] the deleted user or an error
      def delete_user(name:)
        user_or_error(delete("/users/#{name}"))
      end

      # Returns the currently active user sessions
      #
      # @return [Array<Resource>,Error] the currently active sessions or an error
      def user_sessions
        get("/users/sessions")
      end
    end

    private

    def user_or_error(response)
      response.is_a?(Resource) ? User.new(response) : response
    end
  end
end
