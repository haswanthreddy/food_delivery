require "rails_helper"

RSpec.describe "/api/v1/delivery_partners", type: :request do
  let(:delivery_partner) { create(:delivery_partner) }
  let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
  let(:valid_attributes) { attributes_for(:delivery_partner) }
  let(:invalid_attributes) { attributes_for(:delivery_partner, email_address: nil) }
  let(:update_attributes) { { full_name: "Updated Name", phone_number: "9876543210" } }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Delivery Partner" do
        expect {
          post api_v1_delivery_partners_url, params: { delivery_partner: valid_attributes }
        }.to change(DeliveryPartner, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response["message"]).to eq("Delivery partner registered successfully.")
      end
    end

    context "with invalid parameters (missing)" do
      it "does not create a new Delivery Partner and renders a bad request response" do
        expect {
          post api_v1_delivery_partners_url, params: { delivery_partner: invalid_attributes }
        }.to change(DeliveryPartner, :count).by(0)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(json_response["error"]).to eq("Missing mandatory fields.")
      end
    end
  end

  describe "GET /show" do
    context "when a delivery_partner exists and delivery_partner's data is requested" do
      it "renders a successful response" do
        get api_v1_delivery_partner_url(delivery_partner), headers: cookies
        expect(response).to have_http_status(:ok)
      end
    end

    context "when delivery_partner requests another delivery_partner's data" do
      it "renders a forbidden response" do
        get api_v1_delivery_partner_url(id: 0), headers: cookies

        p "json response: #{JSON.parse(response.body)}"

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested delivery_partner" do
        patch api_v1_delivery_partner_url(delivery_partner), params: { delivery_partner: update_attributes }, headers: cookies

        delivery_partner.reload

        expect(delivery_partner.full_name).to eq("Updated Name")
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Delivery partner updated successfully.")
      end
    end
  
    context "with invalid parameters" do
      it "renders an bad_request since email is nil" do
        patch api_v1_delivery_partner_url(delivery_partner), params: { delivery_partner: { email_address: nil } }, headers: cookies

        expect(response).to have_http_status(:bad_request)
      end
    end
    
    context "when trying to update differnt delivery_partner" do
      it "renders a forbidden response" do
        patch api_v1_delivery_partner_url(id: 0), params: { delivery_partner: update_attributes }, headers: cookies
  
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end