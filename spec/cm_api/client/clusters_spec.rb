# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#cluster" do
    context "when cluster is found" do
      it "returns the cluster resource" do
        response = APIClient.cluster(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(response.display_name).to eq("Cloudera QuickStart")
        expect(response).to be_kind_of(CMAPI::Cluster)
      end
    end

    context "when cluster is not found" do
      it "returns a 404 with an appropriate message" do
        response = APIClient.cluster(name: "Cloudera QuickStart1")
        expect(api_request("/clusters/Cloudera QuickStart1")).to have_been_made
        expect(last_response.status).to eq(404)
        expect(response.message).to eq("Cluster 'Cloudera QuickStart1' not found.")
      end
    end
  end

  describe "#clusters" do
    it "lists the managed clusters" do
      response = APIClient.clusters
      expect(api_request("/clusters?view=summary")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response[0].display_name).to eq("Cloudera QuickStart")

      response.each { |resource| expect(resource).to be_kind_of(CMAPI::Cluster) }
    end

    it "accepts a custom view parameter" do
      response = APIClient.clusters(view: "full")
      expect(api_request("/clusters?view=full")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response[0].display_name).to eq("Cloudera QuickStart")
    end

    context "when operation not successful" do
      it "returns an error object" do
        response = APIClient.clusters(view: "unknown_type")
        expect(response).to be_kind_of(CMAPI::Error)
      end
    end
  end

  describe "#create_cluster" do
    context "when operation is successful" do
      it "creates the new cluster and returns the resource" do
        response = APIClient.create_cluster(name: "New Cluster", full_version: "5.8.1")
        expect(api_request("/clusters", method: :post)).to have_been_made
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::Cluster)
        expect(response.name).to eq("New Cluster")
      end
    end

    context "when neither version nor full_version are supplied" do
      it "raises an InvalidCDHVersionError" do
        expect { APIClient.create_cluster(name: "My Cluster") }.to raise_error(CMAPI::InvalidCDHVersionError)
      end
    end

    context "when the operation fails" do
      it "returns the error resource" do
        response = APIClient.create_cluster(name: nil, full_version: "5.8.1") # name already exists
        expect(api_request("/clusters", method: :post)).to have_been_made
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(400)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#update_cluster" do
    context "when the cluster exists" do
      it "supports renaming the cluster" do
        APIClient.create_cluster(name: "To Be Updated", full_version: "5.8.1")
        expect(last_response.status).to eq(200)

        response = APIClient.update_cluster(name: "To Be Updated", new_name: "Updated Cluster")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::Cluster)
        expect(response.display_name).to eq("Updated Cluster")
      end

      it "can update the version of CDH for the cluster" do
        APIClient.create_cluster(name: "Update CDH", full_version: "5.8.0")
        expect(last_response.status).to eq(200)

        response = APIClient.update_cluster(name: "Update CDH", full_version: "5.8.1")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::Cluster)
        expect(response.full_version).to eq("5.8.1")
      end
    end

    context "when the cluster is not found" do
      it "returns the error resource" do
        response = APIClient.update_cluster(name: "Not here", new_name: "Won't be applied")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end

    context "when API version < 2" do
      it "raises UnsupportedVersionError" do
        client = versioned_api_client(version: 1)
        expect { client.update_cluster(name: "Test", new_name: "Doesn't Matter") }.to raise_error(
          CMAPI::UnsupportedVersionError
        )
      end
    end
  end

  describe "#delete_cluster" do
    context "when the cluster exists" do
      it "deletes the cluster" do
        APIClient.create_cluster(name: "To Be Deleted", full_version: "5.8.1")
        expect(last_response.status).to eq(200)

        response = APIClient.delete_cluster(name: "To Be Deleted")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::Cluster)
        expect(response.name).to eq("To Be Deleted")
      end
    end

    context "when the cluster is not found" do
      it "returns an appropriate error resource" do
        response = APIClient.delete_cluster(name: "unknown cluster")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#cluster_service_types" do
    context "when the cluster exists" do
      it "deletes the cluster" do
        response = APIClient.cluster_service_types(name: "Cloudera QuickStart")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(Array)
        expect(response).to include("YARN")
      end
    end

    context "when the cluster is not found" do
      it "returns an appropriate error resource" do
        response = APIClient.cluster_service_types(name: "unknown cluster")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#auto_assign_cluster_roles" do
    context "when successful" do
      it "returns nil" do
        response = APIClient.auto_assign_cluster_roles(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart/autoAssignRoles", method: :put)).to have_been_made
        expect(last_response.status).to eq(204)
        expect(response).to be_nil
      end
    end

    context "when failure occurs" do
      it "returns the error" do
        response = APIClient.auto_assign_cluster_roles(name: "unknown cluster")
        expect(response).to be_kind_of(CMAPI::Error)
      end
    end

    context "when API version < 6" do
      it "raises UnsupportedVersionError" do
        client = versioned_api_client(version: 1)
        expect { client.auto_assign_cluster_roles(name: "Cloudera QuickStart") }.to raise_error(
          CMAPI::UnsupportedVersionError
        )
      end
    end
  end

  describe "#auto_configure_cluster" do
    context "when successful" do
      it "returns nil" do
        response = APIClient.auto_configure_cluster(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart/autoConfigure", method: :put)).to have_been_made
        expect(last_response.status).to eq(204)
        expect(response).to be_nil
      end
    end

    context "when failure occurs" do
      it "returns the error" do
        response = APIClient.auto_configure_cluster(name: "unknown cluster")
        expect(response).to be_kind_of(CMAPI::Error)
      end
    end

    context "when API version < 6" do
      it "raises UnsupportedVersionError" do
        client = versioned_api_client(version: 1)
        expect { client.auto_configure_cluster(name: "Cloudera QuickStart") }.to raise_error(
          CMAPI::UnsupportedVersionError
        )
      end
    end
  end

  describe "#cluster_dfs_services" do
    context "when successful" do
      it "returns an array of DFS services" do
        response = APIClient.cluster_dfs_services(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart/dfsServices?view=summary")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(Array)
        response.each { |service| expect(service).to be_kind_of(CMAPI::Resource) }
      end
    end

    context "when cluster unknown" do
      it "returns an empty array of services" do
        response = APIClient.cluster_dfs_services(name: "unknown cluster")
        expect(response).to be_kind_of(Array)
        expect(response).to be_empty
      end
    end
  end

  describe "#export_cluster" do
    context "when successful" do
      it "returns the configuration object" do
        response = APIClient.export_cluster(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart/export?autoConfig=false")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::Resource)
      end
    end

    context "when an error occurs" do
      it "returns an error" do
        response = APIClient.export_cluster(name: "unknown cluster")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
      end
    end
  end
end
