# frozen_string_literal: true
describe CMAPI::Middleware::Response do
  let(:subject) { described_class.new(nil, APIClient) }

  describe "#parse" do
    it "parses response as json and creates a resource object" do
      json = JSON.generate(data: "value")
      expect(CMAPI::Resources::Base).to receive(:new).with(JSON.parse(json), api_client: APIClient)

      subject.parse(json)
    end
  end
end
