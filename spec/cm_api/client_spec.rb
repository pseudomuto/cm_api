# frozen_string_literal: true
describe CMAPI::Client do
  let(:client) { described_class.new(host: "cloudera-test.com") }

  def api_path(path)
    "http://#{client.host}:#{client.port}/api/v13#{path}"
  end

  describe "initialize" do
    it "defaults port to DEFAULT_PORT" do
      api_client = described_class.new(host: "www.example.com")
      expect(api_client.port).to eq(described_class::DEFAULT_PORT)
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
    context "when response is successful" do
      it "gets the specified resource" do
        request = stub_request(:get, api_path("/tools/echo")).to_return(body: '{ "message": "" }')

        client.get("/tools/echo")
        expect(request).to have_been_requested
      end

      it "adds params as query string params" do
        request = stub_request(:get, api_path("/tools/echo?message=test")).to_return(body: '{ "message": "test" }')

        client.get("/tools/echo", message: "test")
        expect(request).to have_been_requested
      end
    end

    context "when response is unsuccessful" do
      it "returns an error object" do
        stub_request(:get, api_path("/error")).to_return(
          body: '{ "message": "not found" }',
          status: 404
        )

        result = client.get("/error")
        expect(result).to be_kind_of(CMAPI::Error)
        expect(result.status).to eq(404)
        expect(result.message).to eq("not found")
      end
    end
  end

  describe "#post" do
    context "when successful" do
      it "posts to the specified resource" do
        request = stub_request(:post, api_path("/post_test")).to_return(body: '{ "items": [] }')

        client.post("/post_test")
        expect(request).to have_been_requested
      end

      it "sends the body along with the request when supplied" do
        body    = { test: "value" }
        request = stub_request(:post, api_path("/post_test"))
                  .with { |req| req.body == JSON.generate(body) }
                  .to_return(body: '{ "items": [] }')

        client.post("/post_test", body: body)
        expect(request).to have_been_requested
      end
    end

    context "when response is unsuccessful" do
      it "returns an error object" do
        stub_request(:post, api_path("/error")).to_return(
          body: '{ "message": "unknown field or something" }',
          status: 400
        )

        result = client.post("/error")
        expect(result).to be_kind_of(CMAPI::Error)
        expect(result.status).to eq(400)
        expect(result.message).to eq("unknown field or something")
      end
    end
  end

  describe "#put" do
    context "when successful" do
      it "puts to the specified resource" do
        request = stub_request(:put, api_path("/put_test")).to_return(body: '{ "items": [] }')

        client.put("/put_test")
        expect(request).to have_been_requested
      end

      it "sends the body along with the request when supplied" do
        body    = { test: "value" }
        request = stub_request(:put, api_path("/put_test"))
                  .with { |req| req.body == JSON.generate(body) }
                  .to_return(body: '{ "items": [] }')

        client.put("/put_test", body: body)
        expect(request).to have_been_requested
      end
    end

    context "when response is unsuccessful" do
      it "returns an error object" do
        stub_request(:put, api_path("/error")).to_return(
          body: '{ "message": "unknown field or something" }',
          status: 400
        )

        result = client.put("/error")
        expect(result).to be_kind_of(CMAPI::Error)
        expect(result.status).to eq(400)
        expect(result.message).to eq("unknown field or something")
      end
    end
  end

  describe "#delete" do
    context "when successful" do
      it "deletes the specified resource" do
        request = stub_request(:delete, api_path("/clusters/test")).to_return(body: '{ "name": "test" }')

        client.delete("/clusters/test")
        expect(request).to have_been_requested
      end

      it "adds params as query string params" do
        request = stub_request(:delete, api_path("/clusters/test?value=1")).to_return(body: '{ "name": "test" }')

        client.delete("/clusters/test", value: 1)
        expect(request).to have_been_requested
      end
    end

    context "when response is unsuccessful" do
      it "returns an error object" do
        stub_request(:delete, api_path("/error")).to_return(
          body: '{ "message": "not found" }',
          status: 404
        )

        result = client.delete("/error")
        expect(result).to be_kind_of(CMAPI::Error)
        expect(result.status).to eq(404)
        expect(result.message).to eq("not found")
      end
    end
  end
end
