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
      # @return [Resources::Base] the list of managed clusters
      def clusters(view: "summary")
        get("/clusters", view: view)
      end

      # Get cluster details
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster
      # @return [Resources::Base] the cluster resource
      def cluster(name:)
        get("/clusters/#{name}")
      end

      # Create a new cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param name [String] the name of the new cluster
      # @param version [String] the CDH major version (e.g. "CDH5")
      # @param full_version [String] the full version for the cluster (e.g. 5.1.1) version param ignored when specified
      # @return [Resources::Base] the created cluster resource
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
        resource.is_a?(Array) ? resource.first : resource
      end

      # Rename an existing cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the existing cluster
      # @param new_name [String] the new name for the cluster
      # @return [Resources::Base] the updated cluster
      def rename_cluster(name:, new_name:)
        body = { displayName: new_name }
        body = { name: new_name } if version < 6

        put("/clusters/#{name}", body: body)
      end

      # Update the CDH version for a cluster.
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster
      # @param full_version [String] the full version for the cluster (e.g. 5.8.1)
      # @return [Resources::Base] the updated cluster
      def update_cluster_version(name:, full_version:)
        put("/clusters/#{name}", body: { fullVersion: full_version })
      end

      # Deletes the specified cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster to delete
      # @return [Resources::Base] the deleted cluster
      def delete_cluster(name:)
        delete("/clusters/#{name}")
      end

      # Gets the supported service types for a cluster
      #
      # @param name [String] the name of the cluster
      # @return [Resources::Base] the supported service types (names)
      def cluster_service_types(name:)
        get("/clusters/#{name}/serviceTypes")
      end

      private

      def ensure_valid_version!(version:, full_version:)
        raise InvalidCDHVersionError, "a version must be supplied" unless version || full_version
      end
    end
  end
end
