# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#echo" do
    it "returns the supplied message" do
      response = APIClient.echo(message: "Some message")
      expect(api_request("/tools/echo?message=Some message")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(response.message).to eq("Some message")
    end
  end

  describe "#echo_error" do
    it "returns the supplied error message" do
      response = APIClient.echo_error(message: "Some error message")
      expect(api_request("/tools/echoError?message=Some error message")).to have_been_made
      expect(last_response.status).to eq(500)
      expect(response.message).to eq("Some error message")
    end
  end
end
