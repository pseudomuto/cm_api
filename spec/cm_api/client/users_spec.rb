# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#users" do
    it "lists users" do
      users = APIClient.users
      expect(api_request("/users")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(users).to be_kind_of(Array)
    end
  end

  describe "#user" do
    context "when user is found" do
      it "shows user details" do
        user = APIClient.user(username: "admin")
        expect(api_request("/users/admin")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(user.name).to eq("admin")
        expect(user.roles).to include("ROLE_ADMIN")
      end
    end

    context "when user is not found" do
      it "returns an error" do
        response = APIClient.user(username: "whodis")
        expect(last_response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#create_user" do
    context "when the username doesn't already exist" do
      it "creates a new user account" do
        response = APIClient.create_user(name: "tester", password: "I know, this should be better")
        expect(last_response.status).to eq(200)
        expect(response.name).to eq("tester")
        expect(response.roles).to include("ROLE_USER")
      end
    end

    context "when the username is already taken" do
      it "returns an error" do
        response = APIClient.create_user(name: "admin", password: "I know, this should be better")
        expect(last_response.status).to eq(400)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#user_sessions" do
    it "lists user sessions" do
      sessions = APIClient.user_sessions
      expect(api_request("/users/sessions")).to have_been_made
      expect(last_response.status).to eq(200)
      expect(sessions).to be_kind_of(Array)
    end
  end
end
