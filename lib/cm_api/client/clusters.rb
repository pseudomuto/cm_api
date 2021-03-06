# frozen_string_literal: true
module CMAPI
  class Client
    # Top level API endpoints in /clusters
    module Clusters
      using Refinements

      # List all managed clusters
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param view [String] the view to return.
      #   Valid values are summary (default), full, full_with_health_check_explanation, export, export_redacted
      # @return [Array<Cluster>, Error] the list of managed clusters or an error
      def clusters(view: "summary")
        response = get("/clusters", view: view)
        return response if response.is_a?(Error)

        response.map(&Cluster.method(:new))
      end

      # Get cluster details
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster
      # @return [Cluster, Error] the cluster resource or an error
      def cluster(name:)
        cluster_or_error(get("/clusters/#{name}"))
      end

      # Create a new cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param name [String] the name of the new cluster
      # @param version [String] the CDH major version (e.g. "CDH5")
      # @param full_version [String] the full version for the cluster (e.g. 5.1.1) version param ignored when specified
      # @return [Cluster, Error] the created cluster resource or an error
      #
      # @note Either version or full_version must be supplied
      def create_cluster(name:, version: nil, full_version: nil)
        ensure_valid_version!(version: version, full_version: full_version)

        body = {
          name: name,
          version: version,
          fullVersion: full_version
        }

        resource = post("/clusters", body: { items: [body] })
        resource.is_a?(Array) ? Cluster.new(resource.first) : resource
      end

      # Update an existing cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      # @raise [UnsupportedVersionError] when version < 2
      # @since 2
      #
      # @param name [String] the name of the cluster to update
      # @param new_name [String] the new name for the cluster or `nil` to leave as is
      # @param full_version [String] the full CDH version for the cluster or `nil` to leave as is
      # @return [Cluster, Error] the updated cluster or an error
      def update_cluster(name:, new_name: nil, full_version: nil)
        enforce_min_version!(2)

        body = {}
        body[:displayName] = new_name if new_name.present?
        body[:fullVersion] = full_version if full_version.present?

        # API < 6: use the name field rather than displaytName
        body[:name] = body.delete(:displayName) if body.key?(:displayName) && version < 6

        cluster_or_error(put("/clusters/#{name}", body: body))
      end

      # Deletes the specified cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster to delete
      # @return [Cluster, Error] the deleted cluster or an error
      def delete_cluster(name:)
        cluster_or_error(delete("/clusters/#{name}"))
      end

      # Gets the supported service types for a cluster
      #
      # @param name [String] the name of the cluster
      # @return [Array<String>, Error] the supported service types (names)
      def cluster_service_types(name:)
        get("/clusters/#{name}/serviceTypes")
      end

      # Automatically assign roles to hosts and create the roles for all the services in a cluster.
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-_autoAssignRoles.html
      # @raise [UnsupportedVersionError] when version < 6
      # @since 6
      #
      # @param name [String] the cluster to assign roles for
      # @return [nil, Error] nil when successful, otherwise the error
      def auto_assign_cluster_roles(name:)
        enforce_min_version!(6)

        response = put("/clusters/#{name}/autoAssignRoles")
        response.blank? ? nil : response
      end

      # Automatically configure roles and services in a cluster.
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-_autoConfigure.html
      # @raise [UnsupportedVersionError] when version < 6
      # @since 6
      #
      # @param name [String] the cluster to configure
      # @return [nil, Error] nil when successful, otherwise the error
      def auto_configure_cluster(name:)
        enforce_min_version!(6)

        response = put("/clusters/#{name}/autoConfigure")
        response.blank? ? nil : response
      end

      # List the services that can provide distributed file system (DFS) capabilities in a cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-_dfsServices.html
      #
      # @param name [String] the cluster to configure
      # @param view [String] the view to return.
      #   Valid values are summary (default), full, full_with_health_check_explanation, export, export_redacted
      # @return [Array<Resource>] the list of services
      def cluster_dfs_services(name:, view: "summary")
        get("/clusters/#{name}/dfsServices", view: view)
      end

      # Export the cluster template for the given cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-_export.html
      #
      # @param name [String] the cluster to export
      # @param auto_config [Boolean] whether or not to export configs set by auto configuration (default: false)
      # @return [Resource, Error] the configuration for the cluster or an error
      def export_cluster(name:, auto_config: false)
        get("/clusters/#{name}/export", autoConfig: auto_config)
      end

      private

      def ensure_valid_version!(version:, full_version:)
        raise InvalidCDHVersionError, "a version must be supplied" unless version || full_version
      end

      def cluster_or_error(response)
        response.is_a?(Resource) ? Cluster.new(response) : response
      end
    end
  end
end
