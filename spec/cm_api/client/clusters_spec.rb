# frozen_string_literal: true
describe CMAPI::Client, :vcr do
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
