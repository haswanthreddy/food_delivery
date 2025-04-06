require "rails_helper"

RSpec.describe "/api/v1/establishments/:establishment_id/products", type: :request do
  
  describe "GET /index" do
    context "when establishment and product exist" do
      let(:establishment) { create(:establishment) }
      let(:product) { create(:product, establishment: establishment) }
      let(:inventory) { create(:inventory, product: product, establishment: establishment, quantity: rand(1..100)) }

      before do
        inventory
      end

      it "returns a successful response with JSON content type" do
        get api_v1_establishment_products_url(establishment_id: establishment.id)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the product data" do
        get api_v1_establishment_products_url(establishment_id: establishment.id)

        json_response = JSON.parse(response.body)

        expect(json_response["data"].length).to eq(1)
        expect(json_response["data"].first["id"]).to eq(product.id)
        expect(json_response["data"].first.keys).to include("id", "establishment_id", "name", "description", "price")
      end

      it "returns the correct response format with pagination metadata" do
        get api_v1_establishment_products_url(establishment_id: establishment.id)

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => hash_including(
            "total_pages",
            "current_page"
          )
        )
      end
    end

    context "when establishment does not exist" do
      let(:establishment_id) { -1 }

      it "returns a not found response with error message" do
        get api_v1_establishment_products_url(establishment_id: establishment_id)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(json_response["error"]).to eq("Establishment not found.")
      end
    end

    context "when multiple products exist" do
      let(:establishment) { create(:establishment) }

      before do
        50.times do |i|
          product = create(:product, name: "#{Faker::Food.dish} - #{i+1}", establishment: establishment)

          create(:inventory, product: product, establishment: establishment, quantity: rand(1..100))
        end
      end

      it "returns the first page of products with a length of 30" do
        get api_v1_establishment_products_url(establishment_id: establishment.id, page: 1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response["data"].length).to eq(30)
      end

      it "orders products by rating in descending order" do
        get api_v1_establishment_products_url(establishment_id: establishment.id, page: 1)

        json_response = JSON.parse(response.body)
        
        ratings = json_response["data"].map { |p| p["rating"] }
        expect(ratings).to eq(ratings.sort.reverse)
      end

      it "returns the correct response format with pagination metadata" do
        get api_v1_establishment_products_url(establishment_id: establishment.id)

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => hash_including(
            "total_pages",
            "current_page"
          )
        )
      end
    end

    context "when products with quantity 0 exist" do
      let(:establishment) { create(:establishment) }

      before do
        product = create(:product, establishment: establishment)
        create(:inventory, product: product, establishment: establishment, quantity: 0)
      end

      it "does not show them in products list" do
        get api_v1_establishment_products_url(establishment_id: establishment.id)

        json_response = JSON.parse(response.body)

        expect(json_response["data"].length).to eq(0)
      end
    end
  end

  describe "GET /show" do
    let(:establishment) { create(:establishment) }
    let(:product) { create(:product, establishment: establishment) }

    context "when establishment and product exist" do
      it "returns a successful response with JSON content type" do
        p "product: #{product.inspect} -----------------$$$$$$$$"
        
        get api_v1_establishment_product_url(establishment_id: establishment.id, id: product.id)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the product data" do
        get api_v1_establishment_product_url(establishment_id: establishment.id, id: product.id)

        json_response = JSON.parse(response.body)

        expect(json_response["data"]["id"]).to eq(product.id)
        expect(json_response["data"].keys).to include("id", "establishment_id", "name", "description", "price")
      end

      it "returns the correct response format" do
        get api_v1_establishment_product_url(establishment_id: establishment.id, id: product.id)

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Hash)
        )
      end
    end

    context "when establishment does not exist" do
      it "returns a not found response with error message" do
        get api_v1_establishment_product_url(establishment_id: -1, id: product.id)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(json_response["error"]).to eq("Establishment not found.")
      end
    end

    context "when product does not exist" do
      it "returns a not found response with error message" do
        get api_v1_establishment_product_url(establishment_id: establishment.id, id: -1)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(json_response["error"]).to eq("Product not found.")
      end
    end
  end
end
