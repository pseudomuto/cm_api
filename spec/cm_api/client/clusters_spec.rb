# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#cluster" do
    context "when cluster is found" do
      it "returns the cluster resource" do
        response = APIClient.cluster(name: "Cloudera QuickStart")
        expect(api_request("/clusters/Cloudera QuickStart")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(response.displayName).to eq("Cloudera QuickStart")
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
      expect(response.items[0].displayName).to eq("Cloudera QuickStart")
    end

    it "accepts a custom view parameter" do
      response = APIClient.clusters(view: "full")
      expect(api_request("/clusters?view=full")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response.items[0].displayName).to eq("Cloudera QuickStart")
    end
  end

  describe "#create_cluster" do
    context "when operation is successful" do
      it "creates the new cluster and returns the resource" do
        response = APIClient.create_cluster(name: "New Cluster", full_version: "5.8.1")
        expect(api_request("/clusters", method: :post)).to have_been_made
        expect(last_response.status).to eq(200)
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
        expect(last_response.status).to eq(400)
        expect(response.message).to_not be_empty
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
        expect(response.name).to eq("To Be Deleted")
      end
    end

    context "when the cluster is not found" do
      it "returns an appropriate error resource" do
        response = APIClient.delete_cluster(name: "unknown cluster")
        expect(last_response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#cluster_service_types" do
    context "when the cluster exists" do
      it "deletes the cluster" do
        response = APIClient.cluster_service_types(name: "Cloudera QuickStart")
        expect(last_response.status).to eq(200)
        expect(response.items).to include("YARN")
      end
    end

    context "when the cluster is not found" do
      it "returns an appropriate error resource" do
        response = APIClient.cluster_service_types(name: "unknown cluster")
        expect(last_response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end
end
