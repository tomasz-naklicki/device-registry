require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /api/signup" do
    context "with valid params" do
      let(:valid_params) do
        {
          user: {
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "creates a new user and returns token + user info" do
        expect {
          post '/api/signup', params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["token"]).to be_present
        expect(json["user"]).to include(
          "id" => User.last.id,
          "email" => "newuser@example.com"
        )
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          user: {
            email: "bademail",
            password: "short",
            password_confirmation: "different"
          }
        }
      end

      it "does not create a user and returns errors" do
        expect {
          post '/api/signup', params: invalid_params
        }.not_to change(User, :count)

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_an(Array)
      end
    end
  end
end
