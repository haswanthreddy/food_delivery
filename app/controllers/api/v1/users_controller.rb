class Api::V1::UsersController < ApplicationController
  before_action :require_authentication, only: %i[ show update ]
  before_action :set_user, only: %i[ show update ]
  before_action :authorize_user, only: [:show, :update]

  def create
    user = User.new(create_user_params)

    if user.save
      render json: {
        status: "success",
        code: 201,
        data: { full_name: user.full_name, email_address: user.email_address, phone_number: user.phone_number},
        message: "User registered successfully."
      }, status: :created
    else
      render json: {
        status: "failure",
        code: 422,
        error: "Signup failed."
      }, status: :unprocessable_entity
    end
  end

  def show
    if @user
      render json: {
        status: "success",
        code: 200,
        data: {
          full_name: @user.full_name,
          email_address: @user.email_address,
          phone_number: @user.phone_number
        }
      }, status: :ok
    else
      render json: {
        status: "failure",
        code: 404,
        error: "User not found."
      }, status: :not_found
    end
  end

  def update
    if @user.update(user_params)
      render json: {
        status: "success",
        code: 200,
        data: { full_name: @user.full_name, email_address: @user.email_address, phone_number: @user.phone_number },
        message: "User updated successfully."
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

  def set_user
    @user ||= User.find_by(id: Current.session.resource.id)
  end

  def authorize_user
    unless Current.session.resource_type == "User" && @user.id == params[:id].to_i
      render json: { status: "failure", code: 403, error: "User is not authorized access" }, status: :forbidden
    end
  end

  def create_user_params
    params.require(:user).permit(:full_name, :phone_number, :email_address, :password)
  end

  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email_address)
  end
end