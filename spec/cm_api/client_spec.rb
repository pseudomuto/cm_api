# frozen_string_literal: true
describe CMAPI::Client do
  describe "initialize" do
    it "defaults port to DEFAULT_PORT" do
      client = described_class.new(host: "www.example.com")
      expect(client.port).to eq(described_class::DEFAULT_PORT)
    end

    context "when host not valid" do
      it "raises InvalidHostError" do
        expect { described_class.new(host: nil) }.to raise_error(CMAPI::InvalidHostError)
        expect { described_class.new(host: "") }.to raise_error(CMAPI::InvalidHostError)
        expect { described_class.new(host: "    ") }.to raise_error(CMAPI::InvalidHostError)
      end
    end
  end

  describe "#get" do
    let(:client) { described_class.new(host: "cloudera-test.com") }

    it "gets the specified resource" do
      request = stub_request(:get, "http://cloudera-test.com:7180/api/v13/tools/echo").to_return(
        body: '{ "message": "" }'
      )

      client.get("/tools/echo")
      expect(request).to have_been_requested
    end

    it "adds params as query string params" do
      request = stub_request(:get, "http://cloudera-test.com:7180/api/v13/tools/echo?message=test").to_return(
        body: '{ "message": "test" }'
      )

      client.get("/tools/echo", message: "test")
      expect(request).to have_been_requested
    end
  end

  describe "#post" do
    let(:client) { described_class.new(host: "cloudera-test.com") }

    it "posts to the specified resource" do
      request = stub_request(:post, "http://cloudera-test.com:7180/api/v13/post_test").to_return(
        body: '{ "items": [] }'
      )

      client.post("/post_test")
      expect(request).to have_been_requested
    end

    it "sends the body along with the request when supplied" do
      body    = { test: "value" }
      request = stub_request(:post, "http://cloudera-test.com:7180/api/v13/post_test")
                .with { |req| req.body == JSON.generate(body) }
                .to_return(body: '{ "items": [] }')

      client.post("/post_test", body: body)
      expect(request).to have_been_requested
    end
  end

  describe "#put" do
    let(:client) { described_class.new(host: "cloudera-test.com") }

    it "puts to the specified resource" do
      request = stub_request(:put, "http://cloudera-test.com:7180/api/v13/put_test").to_return(
        body: '{ "items": [] }'
      )

      client.put("/put_test")
      expect(request).to have_been_requested
    end

    it "sends the body along with the request when supplied" do
      body    = { test: "value" }
      request = stub_request(:put, "http://cloudera-test.com:7180/api/v13/put_test")
                .with { |req| req.body == JSON.generate(body) }
                .to_return(body: '{ "items": [] }')

      client.put("/put_test", body: body)
      expect(request).to have_been_requested
    end
  end

  describe "#delete" do
    let(:client) { described_class.new(host: "cloudera-test.com") }

    it "deletes the specified resource" do
      request = stub_request(:delete, "http://cloudera-test.com:7180/api/v13/clusters/test").to_return(
        body: '{ "name": "test" }'
      )

      client.delete("/clusters/test")
      expect(request).to have_been_requested
    end

    it "adds params as query string params" do
      request = stub_request(:delete, "http://cloudera-test.com:7180/api/v13/clusters/test?value=1").to_return(
        body: '{ "name": "test" }'
      )

      client.delete("/clusters/test", value: 1)
      expect(request).to have_been_requested
    end
  end
end
