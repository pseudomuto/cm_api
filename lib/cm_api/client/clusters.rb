# frozen_string_literal: true
module CMAPI
  class Client
    # Top level API endpoints in /clusters
    module Clusters
      # List all managed clusters
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param view [String] the view to return.
      #   Valid values are summary (default), full, full_with_health_check_explanation, export, export_redacted
      # @return [Array<Cluster>,Error] the list of managed clusters or an error
      def clusters(view: "summary")
        response = get("/clusters", view: view)
        return response if response.is_a?(Error)

        response.map(&Cluster.method(:new))
      end

      # Get cluster details
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster
      # @return [Cluster,Error] the cluster resource or an error
      def cluster(name:)
        cluster_or_error(get("/clusters/#{name}"))
      end

      # Create a new cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param name [String] the name of the new cluster
      # @param version [String] the CDH major version (e.g. "CDH5")
      # @param full_version [String] the full version for the cluster (e.g. 5.1.1) version param ignored when specified
      # @return [Cluster,Error] the created cluster resource or an error
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

      # Rename an existing cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      # @raise [UnsupportedVersionError] when version < 2
      #
      # @param name [String] the name of the existing cluster
      # @param new_name [String] the new name for the cluster
      # @return [Cluster,Error] the updated cluster or an error
      def rename_cluster(name:, new_name:)
        enforce_min_version!(2)
        body = { displayName: new_name }
        body = { name: new_name } if version < 6

        response = put("/clusters/#{name}", body: body)
        cluster_or_error(response)
      end

      # Update the CDH version for a cluster.
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      # @raise [UnsupportedVersionError] when version < 2
      #
      # @param name [String] the name of the cluster
      # @param full_version [String] the full version for the cluster (e.g. 5.8.1)
      # @return [Cluster,Error] the updated cluster or an error
      def update_cluster_version(name:, full_version:)
        enforce_min_version!(2)

        response = put("/clusters/#{name}", body: { fullVersion: full_version })
        cluster_or_error(response)
      end

      # Deletes the specified cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster to delete
      # @return [Cluster,Error] the deleted cluster or an error
      def delete_cluster(name:)
        cluster_or_error(delete("/clusters/#{name}"))
      end

      # Gets the supported service types for a cluster
      #
      # @param name [String] the name of the cluster
      # @return [Array<String>,Error] the supported service types (names)
      def cluster_service_types(name:)
        get("/clusters/#{name}/serviceTypes")
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
