class Api::V1::ProductsController < ApplicationController
  before_action :set_establishment
  before_action :set_product, only: :show

  def index
    products = @establishment.products.joins(:inventories)
                      .where('inventories.quantity > ?', 1)
                      .order(rating: :desc)
                      .page(params[:page])
                      .per(30)

    render json: {
      code: 200,
      status: "success",
      data: products,
      meta: {
        total_pages: products.total_pages,
        current_page: products.current_page,
      }
    }, status: :ok
  end

  def show
    render json: {
      code: 200,
      status: "success",
      data: @product
    }, status: :ok
  end

  private

  def set_establishment
    @establishment = Establishment.find_by(id: params[:establishment_id])

    unless @establishment.present?
      render json: {
        code: 404,
        status: "failure",
        error: "Establishment not found."
      }, status: :not_found
    end
  end

  def set_product
    @product = Product.find_by(id: params[:id])

    unless @product.present?
      render json: {
        code: 404,
        status: "failure",
        error: "Product not found."
      }, status: :not_found
    end
  end
end