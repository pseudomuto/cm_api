# frozen_string_literal: true
describe CMAPI::Client, :vcr do
  describe "#users" do
    context "when successful" do
      it "lists users" do
        users = APIClient.users
        expect(api_request("/users?view=summary")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(users).to be_kind_of(Array)

        users.each { |user| expect(user).to be_kind_of(CMAPI::User) }
      end
    end

    context "when request fails" do
      it "returns an error object" do
        response = APIClient.users(view: "unknown_view")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#user" do
    context "when user is found" do
      it "shows user details" do
        user = APIClient.user(name: "admin")
        expect(api_request("/users/admin")).to have_been_made
        expect(last_response.status).to eq(200)
        expect(user).to be_kind_of(CMAPI::User)
        expect(user.name).to eq("admin")
        expect(user.roles).to include("ROLE_ADMIN")
      end
    end

    context "when user is not found" do
      it "returns an error" do
        response = APIClient.user(name: "whodis")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#create_user" do
    context "when the username doesn't already exist" do
      it "creates a new user account" do
        response = APIClient.create_user(name: "tester", password: "I know, this should be better")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::User)
        expect(response.name).to eq("tester")
        expect(response.roles).to include("ROLE_USER")
      end
    end

    context "when the username is already taken" do
      it "returns an error" do
        response = APIClient.create_user(name: "admin", password: "I know, this should be better")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(400)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#update_user" do
    context "when neither password nor roles are supplied" do
      it "fetches the user details" do
        APIClient.update_user(name: "admin")
        expect(api_request("/users/admin", method: :get)).to have_been_made
      end
    end

    context "when password and roles supplied" do
      it "updates the user" do
        APIClient.create_user(name: "updater", password: "will be updated")
        expect(last_response.status).to eq(200)

        response = APIClient.update_user(name: "updater", password: "NewPass", roles: %w(ROLE_ADMIN))
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::User)
        expect(response.roles).to include("ROLE_ADMIN")
        expect(response.roles).to_not include("ROLE_USER")
      end
    end

    context "when the user doesn't exist" do
      it "returns an error" do
        response = APIClient.update_user(name: "notme", password: "someRandoPass")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
        expect(response.message).to_not be_empty
      end
    end
  end

  describe "#delete_user" do
    context "when the user exists" do
      it "deletes the user from CDM" do
        APIClient.create_user(name: "deleteme", password: "SuperSECRET!")
        expect(last_response.status).to eq(200)

        response = APIClient.delete_user(name: "deleteme")
        expect(last_response.status).to eq(200)
        expect(response).to be_kind_of(CMAPI::User)
        expect(response.name).to eq("deleteme")
      end
    end

    context "when the user doesn't exist" do
      it "returns an error" do
        response = APIClient.delete_user(name: "notfoundhere")
        expect(response).to be_kind_of(CMAPI::Error)
        expect(response.status).to eq(404)
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
