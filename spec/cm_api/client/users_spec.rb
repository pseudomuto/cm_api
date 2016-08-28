# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#users" do
    it "lists users" do
      users = APIClient.users
      expect(APIClient.last_response.status).to eq(200)
      expect(users.items).to be_kind_of(Array)
    end
  end

  describe "#user" do
    it "shows user details" do
      user = APIClient.user(username: "admin")
      expect(APIClient.last_response.status).to eq(200)
      expect(user.name).to eq("admin")
      expect(user.roles).to include("ROLE_ADMIN")
    end
  end

  describe "#user_sessions" do
    it "lists user sessions" do
      sessions = APIClient.user_sessions
      expect(APIClient.last_response.status).to eq(200)
      expect(sessions.items).to be_kind_of(Array)
    end
  end
end
