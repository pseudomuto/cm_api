# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#users" do
    it "lists users" do
      users = APIClient.users
      expect(api_request("/users")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(users.items).to be_kind_of(Array)
    end
  end

  describe "#user" do
    it "shows user details" do
      user = APIClient.user(username: "admin")
      expect(api_request("/users/admin")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(user.name).to eq("admin")
      expect(user.roles).to include("ROLE_ADMIN")
    end
  end

  describe "#user_sessions" do
    it "lists user sessions" do
      sessions = APIClient.user_sessions
      expect(api_request("/users/sessions")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(sessions.items).to be_kind_of(Array)
    end
  end
end
