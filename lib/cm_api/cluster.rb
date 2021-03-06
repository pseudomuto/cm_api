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

    # List the services that can provide distributed file system (DFS) capabilities in a cluster
    #
    # @param view [String] the view to return.
    #   Valid values are summary (default), full, full_with_health_check_explanation, export, export_redacted
    # @return [Array<Resource>] the list of services
    def dfs_services(view: "summary")
      api_client.cluster_dfs_services(name: name, view: view)
    end

    # Export the cluster template for this cluster
    #
    # @param auto_config [Boolean] whether or not to export configs set by auto configuration (default: false)
    # @return [Resource, Error] the configuration for the cluster or an error
    def export(auto_config: false)
      api_client.export_cluster(name: name, auto_config: auto_config)
    end
  end
end
