# frozen_string_literal: true
APIClient = CMAPI::Client.new(host: "localhost", user: "cloudera", pass: "cloudera")

def versioned_api_client(version:)
  CMAPI::Client.new(host: "localhost", user: "cloudera", pass: "cloudera", version: version)
end

def last_response
  APIClient.last_response
end

def api_request(path, method: :get)
  a_request(method, "http://localhost:7180/api/v13#{path}")
end
