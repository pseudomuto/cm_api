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
      # @return [Resource] the list of managed clusters
      def clusters(view: "summary")
        get("/clusters", view: view)
      end

      # Get cluster details
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster
      # @return [Resource] the cluster resource
      def cluster(name:)
        get("/clusters/#{name}")
      end

      # Create a new cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters.html
      #
      # @param name [String] the name of the new cluster
      # @param version [String] the CDH major version (e.g. "CDH5")
      # @param full_version [String] the full version for the cluster (e.g. 5.1.1) version param ignored when specified
      # @return [Resource] the created cluster resource
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
        resource.respond_to?(:items) ? resource.items.first : resource
      end

      # Deletes the specified cluster
      # @see http://cloudera.github.io/cm_api/apidocs/v13/path__clusters_-clusterName-.html
      #
      # @param name [String] the name of the cluster to delete
      # @return [Resource] the deleted cluster
      def delete_cluster(name:)
        delete("/clusters/#{name}")
      end

      private

      def ensure_valid_version!(version:, full_version:)
        raise InvalidCDHVersionError, "a version must be supplied" unless version || full_version
      end
    end
  end
end
