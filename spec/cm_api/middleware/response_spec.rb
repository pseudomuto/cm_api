# frozen_string_literal: true
describe CMAPI::Middleware::Response do
  let(:subject) { described_class.new }

  describe "#parse" do
    it "parses response as json and creates an entity" do
      json = JSON.generate(data: "value")
      expect(CMAPI::Resource).to receive(:new).with(JSON.parse(json))

      subject.parse(json)
    end
  end
end
