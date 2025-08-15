require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST #login" do
    let(:user) { create(:user, password: "secret", password_confirmation: "secret") }

    context "with valid credentials" do
      it "authenticates the user and returns a token" do
        post :create, params: { email: user.email, password: "secret" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
        expect(ApiKey.exists?(token: json["token"])).to be_truthy
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized" do
        post :create, params: { email: user.email, password: "wrong" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #logout" do
    let(:api_key) { create(:api_key) }
    let(:user) { api_key.bearer }

    context "with valid token" do
      it "destroys the api key" do
        delete :destroy, session: { token: api_key.token }
        expect(ApiKey.exists?(token: api_key.token)).to eq(false)
        

        expect(response).to have_http_status(:no_content)
      end
    end

    context "with invalid token" do
      it "does nothing and still returns no_content" do
        expect {
          delete :destroy, session: { token: api_key.token }
        }.not_to change(ApiKey, :count)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end



# token = request.headers['Authorization']&.split&.last
#     api_key = ApiKey.find_by(token: token)