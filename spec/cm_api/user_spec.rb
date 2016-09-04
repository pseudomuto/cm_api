# frozen_string_literal: true
describe CMAPI::User do
  let(:api_client) { instance_spy(CMAPI::Client) }
  let(:subject) { described_class.new(OpenStruct.new(name: "admin", api_client: api_client)) }

  describe "#change_password" do
    it "delegates to the api client" do
      subject.change_password(password: "newPassword1")
      expect(api_client).to have_received(:update_user).with(name: "admin", password: "newPassword1")
    end
  end

  describe "#update_roles" do
    it "delegates to the api client" do
      subject.update_roles(roles: "ROLE_USER")
      expect(api_client).to have_received(:update_user).with(name: "admin", roles: %w(ROLE_USER))
    end
  end
end
