# frozen_string_literal: true
module CMAPI
  # A class that represents a CDM user. This class will delegate calls to a {Resource} object when a method is not
  # defined here.
  class User < SimpleDelegator
    # Change this user's password
    #
    # @param password [String] the new password
    # @return [User, Error] the updated user or an error
    def change_password(password:)
      api_client.update_user(name: name, password: password)
    end

    # Update this user's roles
    #
    # @param roles [String,Array<String>] the new role(s)
    # @return [User, Error] the update user or an error
    def update_roles(roles:)
      api_client.update_user(name: name, roles: Array(roles))
    end
  end
end
