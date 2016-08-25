# frozen_string_literal: true
describe CMAPI::Client do
  describe "initialize" do
    context "when host not valid" do
      it "raises InvalidHostError" do
        expect { described_class.new(host: nil) }.to raise_error(CMAPI::InvalidHostError)
        expect { described_class.new(host: "") }.to raise_error(CMAPI::InvalidHostError)
        expect { described_class.new(host: "    ") }.to raise_error(CMAPI::InvalidHostError)
      end
    end

    context "when port is supplied" do
      it "uses the supplied port" do
        client = described_class.new(host: "www.example.com", port: 1234)
        expect(client.port).to eq(1234)
      end

      it "uses the supplied port even when secure flag is true" do
        client = described_class.new(host: "www.example.com", port: 1234, secure: true)
        expect(client.port).to eq(1234)
      end
    end

    context "when port not supplied" do
      it "defaults to DEFAULT_PORT" do
        client = described_class.new(host: "www.example.com")
        expect(client.port).to eq(described_class::DEFAULT_PORT)
      end

      it "uses secure port when tls? is true" do
        client = described_class.new(host: "www.example.com", secure: true)
        expect(client.port).to eq(described_class::DEFAULT_SECURE_PORT)
      end
    end
  end
end
