require "rails_helper"

RSpec.describe "/api/v1/delivery_partners/sessions", type: :request do
  let(:delivery_partner) { create(:delivery_partner, email_address: "delivery_partner@example.com", password: "password123") }

  let(:valid_params) do
    { email_address: delivery_partner.email_address, password: delivery_partner.password }
  end

  let(:wrong_email_params) do
    { email_address: "delivery@example.com", password: delivery_partner.password }
  end

  let(:wrong_password_params) do
    { email_address: delivery_partner.email_address, password: "password" }
  end

  describe "POST /create" do
    context "with valid params" do
      it "should return ok status" do
        post api_v1_delivery_partners_sessions_url, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should set cookie" do
        post api_v1_delivery_partners_sessions_url, params: valid_params

        expect(response.headers["Set-Cookie"]).to be_present
      end

      it "should return valid json response" do
        post api_v1_delivery_partners_sessions_url, params: valid_params

        json_response = JSON.parse(response.body)
        code = json_response["code"]
        message = json_response["message"]
        status = json_response["status"]

        expect(code).to eq(200)
        expect(message).to eq("Logged in successfully.")
        expect(status).to eq("success")
      end
    end

    context "with invalid params" do
      it "should return status unauthorized - with wrong email address" do
        post api_v1_delivery_partners_sessions_url, params: wrong_email_params

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should return status unauthorized - with wrong password" do
        post api_v1_delivery_partners_sessions_url, params: wrong_password_params

        expect(response).to have_http_status(:unauthorized)
      end

      it "should return valid json response" do
        post api_v1_delivery_partners_sessions_url, params: wrong_email_params

        json_response = JSON.parse(response.body)
        code = json_response["code"]
        error = json_response["error"]
        status = json_response["status"]

        expect(code).to eq(401)
        expect(error).to eq("Invalid email address or password.")
        expect(status).to eq("failure")
      end
    end

    context "with user params" do
      it "should not authorize" do
        user = create(:user)

        post api_v1_delivery_partners_sessions_url, params: { email_address: user.email_address, password: user.password }

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE /destroy" do
    context "when logging out current delivery partner's session" do
      it "should log out the delivery partner and return a success message" do
        post api_v1_delivery_partners_sessions_url, params: valid_params

        expect(response).to have_http_status(:ok)

        delete api_v1_delivery_partners_sessions_url

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(json_response["message"]).to eq("Logged out successfully.")
        expect(Session.find_by(id: session.id)).to be_nil
        expect(cookies["session_id"]).to eq("")
      end
    end
  end
end