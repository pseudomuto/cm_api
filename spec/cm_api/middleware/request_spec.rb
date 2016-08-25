# frozen_string_literal: true
describe CMAPI::Middleware::Request do
  let(:app) do
    app = double
    allow(app).to receive(:call).with(request)
    app
  end

  let(:request) { { request_headers: {} } }
  let(:subject) { described_class.new(app) }

  describe "#call" do
    before(:each) { subject.call(request) }

    it "sets the content type header to JSON" do
      expect(request.dig(:request_headers, "Content-Type")).to eq("application/json")
    end
  end
end
