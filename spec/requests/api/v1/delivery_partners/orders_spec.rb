require "rails_helper"

RSpec.describe "/api/v1/delivery_partners/orders", type: :request do

  describe "GET /show" do
    context "when order exists" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      let(:order) { create(:order, delivery_partner: delivery_partner) }

      it "returns a successful response with JSON content type" do
        get api_v1_delivery_partners_order_url(order.id), headers: cookies

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the order data" do
        get api_v1_delivery_partners_order_url(order.id), headers: cookies

        json_response = JSON.parse(response.body)
        data = json_response["data"]

        establishment = order.product.establishment
        product = order.product
        user = order.user

        expect(data["id"]).to eq(order.id)
        expect(data["status"]).to eq(order.status)
        expect(data["total_price"]).to eq(order.total_price.to_s)

        expect(data["establishment_details"]["name"]).to eq(establishment.name)
        expect(data["establishment_details"]["full_address"]).to eq(establishment.full_address)
        expect(data["establishment_details"]["longitude"]).to eq(establishment.longitude)
        expect(data["establishment_details"]["latitude"]).to eq(establishment.latitude)

        expect(data["user_details"]["full_name"]).to eq(user.full_name)
        expect(data["user_details"]["phone_number"]).to eq(user.phone_number)
        expect(data["user_details"]["longitude"]).to eq(user.longitude)
        expect(data["user_details"]["latitude"]).to eq(user.latitude)

        expect(data["product_details"]["name"]).to eq(product.name)
        expect(data["product_details"]["description"]).to eq(product.description)
        expect(data["product_details"]["price"]).to eq(product.price.to_s)
      end
    end

    context "when order does not exist" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      
      it "returns a 404 not found response" do
        get api_v1_delivery_partners_order_url(0), headers: cookies

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when accessing another delivery partner's order" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:order) { create(:order, delivery_partner: delivery_partner) }
      let(:delivery_partner2) { create(:delivery_partner) }
      let(:cookies2) { login_as(:delivery_partner, delivery_partner2.email_address, delivery_partner2.password) }

      it "returns a 403 forbidden response" do
        get api_v1_delivery_partners_order_url(order.id), headers: cookies2

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /accept" do
    context "when order exists" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      let(:order) { create(:order, delivery_partner: nil) }

      it "returns a successful response" do
        post accept_api_v1_delivery_partners_order_url(order.id), headers: cookies

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "assigns the delivery partner to the order" do
        expect {
          post accept_api_v1_delivery_partners_order_url(order.id), headers: cookies
        }.to change { order.reload.delivery_partner_id }.from(nil).to(delivery_partner.id)
      end

      it "returns the updated order data" do
        post accept_api_v1_delivery_partners_order_url(order.id), headers: cookies

        json_response = JSON.parse(response.body)
        
        expect(json_response["status"]).to eq("success")
        expect(json_response["data"]["id"]).to eq(order.id)
      end
    end

    context "when order does not exist" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      
      it "returns a 404 not found response" do
        post accept_api_v1_delivery_partners_order_url(0), headers: cookies

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when order is already accepted" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      let(:order) { create(:order, delivery_partner: delivery_partner, status: Order.statuses.keys[1]) }

      it "returns unprocessable entity status" do
        post accept_api_v1_delivery_partners_order_url(order.id), headers: cookies

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PATCH /update" do
    context "when order exists" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      let(:order) { create(:order, delivery_partner: delivery_partner) }

      it "returns a successful response" do
        patch api_v1_delivery_partners_order_url(order.id), params: { order: { status: "completed" } }, headers: cookies

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "updates the order status" do
        patch api_v1_delivery_partners_order_url(order.id), params: { order: { status: "completed" } }, headers: cookies

        expect(order.reload.status).to eq("completed")
      end

      it "returns the updated order data" do
        patch api_v1_delivery_partners_order_url(order.id), params: { order: { status: "completed" } }, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["status"]).to eq("success")
        expect(json_response["data"]["id"]).to eq(order.id)
      end
    end

    context "when order does not exist" do
      let(:delivery_partner) { create(:delivery_partner) }
      let(:cookies) { login_as(:delivery_partner, delivery_partner.email_address, delivery_partner.password) }
      
      it "returns a 404 not found response" do
        patch api_v1_delivery_partners_order_url(0), headers: cookies

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end