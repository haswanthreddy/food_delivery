require "rails_helper"

RSpec.describe "/api/v1/users/orders/", type: :request do
  
  describe "GET /index" do
    let(:user) { create(:user) }
    let(:cookies) { login_as(:user, user.email_address, user.password) }

    context "user is not authenticated" do
      it "returns a 401 Unauthorized response" do
        get api_v1_users_orders_url

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "when orders exist" do
      let(:establishment) { create(:establishment) }
      let(:product) { create(:product, establishment: establishment) }
      
      before do
        create_list(:order, 5, user: user, product: product)
      end

      it "retruns a successful response with JSON content type" do
        get api_v1_users_orders_url, headers: cookies

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the orders data" do
        get api_v1_users_orders_url, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["data"].length).to eq(5)

        first_order = json_response["data"].first

        expect(first_order).to include(
          "id", "status", "quantity", "total_price", "created_at",
          "product", "establishment"
        )
        expect(first_order["product"]).to include("id", "name")
        expect(first_order["establishment"]).to include("id", "name")
      end

      it "returns the correct response format" do
        get api_v1_users_orders_url, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => a_hash_including(
            "total_pages",
            "current_page"
          )
        )
      end

      it "returns orders data with accurate attributes" do
        get api_v1_users_orders_url, headers: cookies
        
        json_response = JSON.parse(response.body)
        data = json_response["data"].first
        order = user.orders.last
        
        expect(data["id"]).to eq(order.id)
        expect(data["status"]).to eq(order.status)
        expect(data["quantity"]).to eq(order.quantity)
        expect(data["total_price"]).to eq(order.total_price.to_s)
        expect(data["created_at"]).to be_present
        
        expect(data["product"]["id"]).to eq(order.product_id)
        expect(data["product"]["name"]).to eq(order.product.name)
        
        expect(data["establishment"]["id"]).to eq(order.product.establishment_id)
        expect(data["establishment"]["name"]).to eq(order.product.establishment.name)
      end

      it "returns paginated orders" do
        get api_v1_users_orders_url, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["meta"]["total_pages"]).to be > 0
        expect(json_response["meta"]["current_page"]).to eq(1)
      end
    end

    context "when no orders exist" do
      it "returns an empty array" do
        get api_v1_users_orders_url, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["data"]).to be_empty
      end
    end
  end

  describe "GET /show" do
    context "when order exists" do
      let(:user) { create(:user) }
      let(:cookies) { login_as(:user, user.email_address, user.password) }
      let(:order) { create(:order, user: user) }

      it "returns a successful response with JSON content type" do
        get api_v1_users_order_url(order.id), headers: cookies

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the all requried order data fields" do
        get api_v1_users_order_url(order.id), headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["data"]["id"]).to eq(order.id)
        expect(json_response["data"]).to include(
          "id",
          "status",
          "total_price",
          "rating",
          "review",
          "quantity",
          "created_at",
          "updated_at",
          "product_details",
          "establishment_details"
        )
        
        expect(json_response["data"]["product_details"]).to include(
          "id", "name", "description", "price"
        )
        
        expect(json_response["data"]["establishment_details"]).to include(
          "id", "name", "full_address", "longitude", "latitude", "phone_number"
        )
      end

      it "returns the correct response format" do
        get api_v1_users_order_url(order.id), headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => a_hash_including(
            "id",
            "status",
            "total_price",
            "rating",
            "review",
            "quantity",
            "created_at",
            "updated_at",
            "product_details",
            "establishment_details"
          )
        )
      end

      it "returns data that matches the order attributes" do
        get api_v1_users_order_url(order.id), headers: cookies

        json_response = JSON.parse(response.body)
        data = json_response["data"]

        expect(data["id"]).to eq(order.id)
        expect(data["status"]).to eq(order.status)
        expect(data["quantity"]).to eq(order.quantity)
        expect(data["total_price"]).to eq(order.total_price.to_s)
        expect(data["rating"]).to eq(order.rating.to_s)
        expect(data["review"]).to eq(order.review)
        expect(data["created_at"]).to be_present
        
        expect(data["product_details"]["id"]).to eq(order.product.id)
        expect(data["product_details"]["name"]).to eq(order.product.name)
        expect(data["product_details"]["description"]).to eq(order.product.description)
        expect(data["product_details"]["price"]).to eq(order.product.price.to_s)
        
        expect(data["establishment_details"]["id"]).to eq(order.product.establishment.id)
        expect(data["establishment_details"]["name"]).to eq(order.product.establishment.name)
        expect(data["establishment_details"]["full_address"]).to eq(order.product.establishment.full_address)
        expect(data["establishment_details"]["longitude"]).to eq(order.product.establishment.longitude)
        expect(data["establishment_details"]["latitude"]).to eq(order.product.establishment.latitude)
        expect(data["establishment_details"]["phone_number"]).to eq(order.product.establishment.phone_number)
      end
    end

    context "when order does not exist" do
      let(:user) { create(:user) }
      let(:cookies) { login_as(:user, user.email_address, user.password) }

      it "returns a 404 Not Found response" do
        get api_v1_users_order_url(id: 0), headers: cookies

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns an error message" do
        get api_v1_users_order_url(id: 0), headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("No order found.")
      end
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:cookies) { login_as(:user, user.email_address, user.password) }

    context "with valid params" do
      let(:product) { create(:product) }

      let(:valid_attributes) { attributes_for(:order, product_id: product.id, user_id: user.id) }

      it "creates a new Order" do
        expect {
          post api_v1_users_orders_url, params: { order: valid_attributes }, headers: cookies
        }.to change(Order, :count).by(1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
      end

      it "returns the correct response format" do
        post api_v1_users_orders_url, params: { order: valid_attributes }, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => a_hash_including(
            "id",
            "status",
            "total_price",
            "rating",
            "review",
            "quantity",
            "created_at",
            "updated_at",
            "product_details",
            "establishment_details"
          )
        )
        
        expect(json_response["data"]["product_details"]).to include(
          "id", "name", "description", "price"
        )
        
        expect(json_response["data"]["establishment_details"]).to include(
          "id", "name", "full_address", "longitude", "latitude", "phone_number"
        )
      end

      it "returns the created order data" do
        post api_v1_users_orders_url, params: { order: valid_attributes }, headers: cookies

        json_response = JSON.parse(response.body)
        data = json_response["data"]
        
        expect(data["id"]).to be_present
        expect(data["status"]).to eq("pending")
        expect(data["quantity"]).to eq(valid_attributes[:quantity])
        expect(data["total_price"].to_f).to eq(product.price * valid_attributes[:quantity])
        expect(data["created_at"]).to be_present
        expect(data["updated_at"]).to be_present

        expect(data["product_details"]["id"]).to eq(valid_attributes[:product_id])
        expect(data["product_details"]["name"]).to eq(product.name)
        expect(data["product_details"]["price"]).to eq(product.price.to_s)
        expect(data["product_details"]["description"]).to eq(product.description)

        expect(data["establishment_details"]["id"]).to eq(product.establishment.id)
        expect(data["establishment_details"]["name"]).to eq(product.establishment.name)
        expect(data["establishment_details"]["full_address"]).to eq(product.establishment.full_address)
        expect(data["establishment_details"]["longitude"]).to eq(product.establishment.longitude)
        expect(data["establishment_details"]["latitude"]).to eq(product.establishment.latitude)
        expect(data["establishment_details"]["phone_number"]).to eq(product.establishment.phone_number)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { attributes_for(:order, product_id: nil, user_id: user.id) }

      it "does not create a new Order and renders a bad request response" do
        expect {
          post api_v1_users_orders_url, params: { order: invalid_attributes }, headers: cookies
        }.to change(Order, :count).by(0)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["error"]).to eq(["Product must exist"])
      end
    end

    context "when user is not authenticated" do
      it "returns a 401 Unauthorized response" do
        post api_v1_users_orders_url, params: { order: { product_id: 1, quantity: 2 } }

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PATCH /update" do
    context "when order exists" do
      let(:user) { create(:user) }
      let(:cookies) { login_as(:user, user.email_address, user.password) }
      let(:delivery_partner) { create(:delivery_partner) }

      it "updates the order's status and returns a successful response" do
        order = create(:order, user: user, status: Order.statuses.keys[1], delivery_partner: delivery_partner)

        patch api_v1_users_order_url(order.id), params: { order: { status: "cancelled" } }, headers: cookies

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response["status"]).to eq("success")
        expect(json_response["data"]["status"]).to eq("cancelled")
      end

      it "does not updates the pending order's rating and review" do
        order = create(:order, user: user, status: Order.statuses.keys[0], delivery_partner: nil)

        patch api_v1_users_order_url(order.id), 
          params: { order: { rating: 4.5, review: "Great service!" } }, 
          headers: cookies

        json_response = JSON.parse(response.body)
        
        expect(response).to have_http_status(:ok)
        expect(json_response["data"]["rating"]).to eq(order.rating.to_s)
        expect(json_response["data"]["review"]).to eq(order.review)
      end

      it "updates the completed order's rating and review" do
        order = create(:order, user: user, status: "completed", delivery_partner: delivery_partner)

        patch api_v1_users_order_url(order.id),
          params: { order: { rating: 4.5, review: "Great service!" } },
          headers: cookies

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response["status"]).to eq("success")
        expect(json_response["data"]["rating"]).to eq("4.5")
        expect(json_response["data"]["review"]).to eq("Great service!")
      end
      
      it "returns the correct response format" do
        order = create(:order, user: user, status: "completed", delivery_partner: delivery_partner)
        
        patch api_v1_users_order_url(order.id), 
          params: { order: { rating: 5 } }, 
          headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => a_hash_including(
            "id",
            "status",
            "total_price",
            "rating",
            "review",
            "quantity",
            "created_at",
            "updated_at",
            "product_details",
            "establishment_details"
          )
        )
      end
    end

    context "when order does not exist" do
      let(:user) { create(:user) }
      let(:cookies) { login_as(:user, user.email_address, user.password) }

      it "returns a 404 Not Found response" do
        patch api_v1_users_order_url(id: 0), params: { order: { status: "completed" } }, headers: cookies

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns an error message" do
        patch api_v1_users_order_url(id: 0), params: { order: { status: "completed" } }, headers: cookies

        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("No order found.")
      end
    end
  end
end