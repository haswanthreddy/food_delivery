class Api::V1::DeliveryPartners::SessionsController < ApplicationController
  before_action :require_authentication, only: %i[ destroy ]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { status: "failure", code: :too_many_requests, error: "Too many login attempts. Please try again later" }, status: :too_many_requests }

  def create
    delivery_partner = DeliveryPartner.authenticate_by(delivery_partner_params)

    if delivery_partner
      start_new_session_for delivery_partner
      render json: { status: "success", code: 200, message: "Logged in successfully." }, status: :ok
    else
      render json: { status: "failure", code: 401, error: "Invalid email address or password." }, status: :unauthorized
    end
  end

  def destroy
    if authenticated?
      terminate_session
      render json: { status: "success", code: :ok, message: "Logged out successfully." }, status: :ok
    else
      render json: { status: "failure", code: :not_found, message: "No active session found" }, status: :not_found
    end
  end

  private

  def delivery_partner_params
    params.permit(:email_address, :password)
  end
end
