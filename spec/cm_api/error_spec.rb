# frozen_string_literal: true
describe CMAPI::Error do
  subject do
    response = { "message" => "Not found." }
    resource = CMAPI::Resource.new(response, api_client: APIClient)
    described_class.new(OpenStruct.new(status: 404, body: resource))
  end

  it "pulls the status from the response" do
    expect(subject.status).to eq(404)
  end

  it "pulls the message from the response body" do
    expect(subject.message).to eq("Not found.")
  end
end
