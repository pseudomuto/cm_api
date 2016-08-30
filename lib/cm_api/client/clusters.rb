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
      def list_clusters(view: "summary")
        get("/clusters", view: view)
      end

      # Get cluster details
      # @see x
      #
      # @param name [String] the name of the cluster
      # @return [Resource] the cluster resource
      def cluster(name:)
        get("/clusters/#{name}")
      end
    end
  end
end
