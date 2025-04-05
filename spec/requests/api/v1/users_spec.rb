require "rails_helper"

RSpec.describe "/api/v1/users", type: :request do
  let(:user) { create(:user) }
  let(:cookies) { login_as(:user, user.email_address, user.password) }
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { attributes_for(:user, email_address: nil) }
  let(:update_attributes) { { full_name: "Updated Name", phone_number: "9876543210" } }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post api_v1_users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response["message"]).to eq("User registered successfully.")
      end
    end

    context "with invalid parameters (missing)" do
      it "does not create a new User and renders a bad request response" do
        expect {
          post api_v1_users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(json_response["error"]).to eq("Missing mandatory fields.")
      end
    end
  end

  describe "GET /show" do
    context "when a user exists and user's data is requested" do
      it "renders a successful response" do
        get api_v1_user_url(user), headers: cookies
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user requests another user's data" do
      it "renders a forbidden response" do
        get api_v1_user_url(id: 0), headers: cookies

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested user" do
        patch api_v1_user_url(user), params: { user: update_attributes }, headers: cookies

        user.reload

        expect(user.full_name).to eq("Updated Name")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("User updated successfully.")
      end
    end
  
    context "with invalid parameters" do
      it "renders an bad_request since email is nil" do
        patch api_v1_user_url(user), params: { user: { email_address: nil } }, headers: cookies

        expect(response).to have_http_status(:bad_request)
      end
    end
    
    context "when trying to update differnt user" do
      it "renders a forbidden response" do
        patch api_v1_user_url(id: 0), params: { user: update_attributes }, headers: cookies
  
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end