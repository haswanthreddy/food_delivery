class Api::V1::DeliveryPartnersController < ApplicationController
  before_action :require_authentication, only: %i[show update]
  before_action :set_delivery_partner, only: %i[show update]
  before_action :authorize_delivery_partner, only: [:show, :update]

  def create
    delivery_partner = DeliveryPartner.new(create_delivery_partner_params)

    if delivery_partner.save
      render json: {
        status: "success",
        code: 201,
        data: {
          full_name: delivery_partner.full_name,
          email_address: delivery_partner.email_address,
          phone_number: delivery_partner.phone_number,
          full_address: delivery_partner.full_address,
          longitude: delivery_partner.longitude,
          latitude: delivery_partner.latitude,
          verified: delivery_partner.verified,
        },
        message: "Delivery partner registered successfully."
      }, status: :created
    else
      render json: {
        status: "failure",
        code: 422,
        error: "Signup failed.",
        error: delivery_partner.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    if @delivery_partner
      render json: {
        status: "success",
        code: 200,
        data: {
          full_name: @delivery_partner.full_name,
          email_address: @delivery_partner.email_address,
          phone_number: @delivery_partner.phone_number,
          full_address: @delivery_partner.full_address,
          longitude: @delivery_partner.longitude,
          latitude: @delivery_partner.latitude,
          verified: @delivery_partner.verified,
        },
      }, status: :ok
    else
      render json: {
        status: "failure",
        code: 404,
        error: "Delivery partner not found."
      }, status: :not_found
    end
  end

  def update
    if @delivery_partner.update(delivery_partner_params)
      render json: {
        status: "success",
        code: 200,
        data: {
          full_name: @delivery_partner.full_name,
          email_address: @delivery_partner.email_address,
          phone_number: @delivery_partner.phone_number,
          full_address: @delivery_partner.full_address,
          longitude: @delivery_partner.longitude,
          latitude: @delivery_partner.latitude,
          verified: @delivery_partner.verified,
        },
        message: "Delivery partner updated successfully."
      }, status: :ok
    else
      render json: {
        status: "failure",
        code: 422,
        error: "Update failed.",
      }, status: :unprocessable_entity
    end
  end

  private

  def set_delivery_partner
    @delivery_partner ||= DeliveryPartner.find_by(id: Current.session.resource_id)
  end

  def authorize_delivery_partner
    unless Current.session.resource_type == "DeliveryPartner" && @delivery_partner.id == params[:id].to_i
      render json: {
        status: "failure",
        code: 403,
        error: "Delivery partner is not authorized to access"
      }, status: :forbidden
    end
  end

  def create_delivery_partner_params
    params.require(:delivery_partner).permit(
      :full_name,
      :phone_number,
      :email_address,
      :password,
      :full_address,
      :longitude,
      :latitude,
      :verified
    )
  end

  def delivery_partner_params
    params.require(:delivery_partner).permit(
      :full_name,
      :phone_number,
      :email_address,
      :full_address,
      :longitude,
      :latitude,
      :verified
    )
  end
end