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

  describe "#list_clusters" do
    it "lists the managed clusters" do
      response = APIClient.list_clusters
      expect(api_request("/clusters?view=summary")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response.items[0].displayName).to eq("Cloudera QuickStart")
    end

    it "accepts a custom view parameter" do
      response = APIClient.list_clusters(view: "full")
      expect(api_request("/clusters?view=full")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response.items[0].displayName).to eq("Cloudera QuickStart")
    end
  end
end
