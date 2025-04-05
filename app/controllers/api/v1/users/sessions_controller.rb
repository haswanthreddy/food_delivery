class Api::V1::Users::SessionsController < ApplicationController
  before_action :require_authentication, only: %i[ destroy ]

  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { status: "failure", code: :too_many_requests, error: "Too many login attempts. Please try again later" }, status: :too_many_requests }

  def create
    user = User.authenticate_by(user_params)

    if user
      start_new_session_for user
      render json: { status: "success", code: 200, message: "Logged in successfully." }, status: :ok
    else
      render json: {
        status: "failure",
        code: 401,
        error: "Invalid email address or password."
      }, status: :unauthorized
    end
  end

  def destroy
    terminate_session

    render json: { status: "success", code: :ok, message: "Logged out successfully." }, status: :ok
  end

  private

  def user_params
    params.permit(:email_address, :password)
  end
end
