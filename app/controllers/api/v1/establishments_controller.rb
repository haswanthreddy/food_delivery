class Api::V1::EstablishmentsController < ApplicationController
  before_action :set_establishment, only: :show

  def index
    establishments = Establishment.order(rating: :desc).page(params[:page]).per(30)

    render json: {
      code: 200,
      status: "success",
      data: establishments,
      meta: {
        total_pages: establishments.total_pages,
        current_pages: establishments.current_page,
      }
    }, status: :ok
  end

  def show
    render json: {
      code: 200,
      status: "success",
      data: @establishment
    }, status: :ok
  end

  private

  def set_establishment
    @establishment = Establishment.find_by(id: params[:id])

    unless @establishment.present?

      render json: {
        code: 404,
        status: "failure",
        error: "Establishment not found."
      }, status: :not_found
    end
  end
end