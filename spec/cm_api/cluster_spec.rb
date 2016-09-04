# frozen_string_literal: true
describe CMAPI::Cluster do
  let(:api_client) { instance_spy(CMAPI::Client) }
  let(:subject) { described_class.new(OpenStruct.new(name: "My Cluster", api_client: api_client)) }

  describe "#rename" do
    it "delegates to the api client" do
      subject.rename(new_name: "test")
      expect(api_client).to have_received(:update_cluster).with(name: subject.name, new_name: "test")
    end
  end

  describe "#update_version" do
    it "delegates to the api client" do
      subject.update_version(full_version: "1.2.3")
      expect(api_client).to have_received(:update_cluster).with(name: subject.name, full_version: "1.2.3")
    end
  end
end
