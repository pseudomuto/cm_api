# frozen_string_literal: true
module CMAPI
  # A class that represents a CDM cluster. This class will delegate calls to a {Resource} object when a method is not
  # defined here.
  class Cluster < SimpleDelegator
    # Rename this cluster
    # @raise [UnsupportedVersionError] when API version < 2
    # @since 2
    #
    # @param new_name [String] the new name for this cluster
    # @return [Cluster, Error] the updated cluster or an error
    def rename(new_name:)
      api_client.update_cluster(name: name, new_name: new_name)
    end

    # Updates the CDH version for this cluster
    # @raise [UnsupportedVersionError] when API version < 2
    # @since 2
    #
    # @param full_version [String] the full CDH version to update to (e.g. "5.8.1")
    # @return [Cluster, Error] the updated cluster or an error
    def update_version(full_version:)
      api_client.update_cluster(name: name, full_version: full_version)
    end

    # Automatically assign roles to hosts and create the roles for all the services in this cluster.
    # @raise [UnsupportedVersionError] when version < 6
    # @since 6
    #
    # @return [nil, Error] nil when successful, otherwise the error
    def auto_assign_roles
      api_client.auto_assign_cluster_roles(name: name)
    end

    # Automatically configure roles and services in a cluster.
    # @raise [UnsupportedVersionError] when version < 6
    # @since 6
    #
    # @return [nil, Error] nil when successful, otherwise the error
    def auto_configure
      api_client.auto_configure_cluster(name: name)
    end
  end
end
