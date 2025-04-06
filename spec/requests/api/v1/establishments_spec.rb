require "rails_helper"

RSpec.describe "/api/v1/establishments", type: :request do
  describe "GET /index" do
    context "when establishments exist" do
      let!(:establishment) { create(:establishment) }

      it "returns a successful response with JSON format and content type" do
        get api_v1_establishments_url

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns establishment data" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        establishment_data = json_response["data"].first

        expect(json_response["data"].length).to eq(1)
        expect(json_response["data"].first["id"]).to eq(establishment.id)
        expect(establishment_data.keys).to include(
          "id", "name", "email_address", "full_address", "city",
          "phone_number", "establishment_type", "latitude", "longitude"
        )
      end

      it "returns the correct response format" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => hash_including(
            "total_pages",
            "current_pages"
          )
        )
      end
    end

    context "when multiple establishments exist" do
      before do
        50.times { |i| create(:establishment, name: "Test Establishment #{i + 1}", rating: rand(1..5)) }
      end

      it "returns the first page of establishment data of length 30" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        expect(json_response["data"].length).to eq(30)
      end

      it "orders establishments by rating in descending order" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        
        ratings = json_response["data"].map { |e| e["rating"] }
        expect(ratings).to eq(ratings.sort.reverse)
      end

      it "returns the correct response format with pagination" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => hash_including(
          "total_pages",
          "current_pages"
          )
        )
      end
    end

    context "when no establishments exist" do
      it "returns a successful response with JSON format" do
        get api_v1_establishments_url

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns an empty array" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        expect(json_response["data"]).to eq([])
      end

      it "returns the correct response format" do
        get api_v1_establishments_url

        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Array),
          "meta" => hash_including(
            "total_pages",
            "current_pages"
          )
        )
      end
    end
  end

  describe "GET /show" do
    context "when establishment exists" do
      let!(:establishment) { create(:establishment) }

      it "returns a successful response with JSON format" do
        get api_v1_establishment_url(establishment)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns the establishment data" do
        get api_v1_establishment_url(establishment)

        json_response = JSON.parse(response.body)
        expect(json_response["data"]["id"]).to eq(establishment.id)
      end

      it "response data contains all required fields" do
        get api_v1_establishment_url(establishment)

        json_response = JSON.parse(response.body)
        establishment_data = json_response["data"]

        expect(establishment_data.keys).to include(
          "id", "name", "email_address", "full_address", "city",
          "phone_number", "establishment_type", "latitude", "longitude"
        )
      end

      it "returns the correct response format" do
        get api_v1_establishment_url(establishment)

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "code" => 200,
          "status" => "success",
          "data" => an_instance_of(Hash)
        )
      end
    end

    context "when establishment does not exist" do
      it "returns a not found response with JSON format" do
        get api_v1_establishment_url(id: -1)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "returns an error message" do
        get api_v1_establishment_url(id: -1)

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Establishment not found.")
      end

      it "returns the correct response format" do
        get api_v1_establishment_url(id: -1)

        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          "code" => 404,
          "status" => "failure",
          "error" => an_instance_of(String)
        )
      end
    end
  end
end
