class Api::V1::Users::OrdersController < ApplicationController
  before_action :require_authentication
  before_action :set_user
  before_action :set_order, except: %i[index create]

  def index
    orders_page = @user.orders
      .includes(product: :establishment)
      .order(created_at: :desc)
      .page(params[:page])
      .per(30)

    orders = orders_page.map do |order|
      {
        id: order.id,
        status: order.status,
        quantity: order.quantity,
        total_price: order.total_price.to_s,
        created_at: order.created_at,
        product: {
          id: order.product_id,
          name: order.product&.name
        },
        establishment: {
          id: order.product&.establishment_id,
          name: order.product&.establishment&.name
        }
      }
    end

    render json: {
      code: 200,
      status: "success",
      data: orders,
      meta: {
        total_pages: orders_page.total_pages,
        current_page: orders_page.current_page
      }
    }, status: :ok
  end

  def create
    order = @user.orders.new(create_order_params)

    if order.save
      render json: {
        code: 200,
        status: "success",
        data: order_data(order)
      }, status: :created
    else
      render json: {
        code: 422,
        status: "failure",
        error: order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      code: 200,
      status: "success",
      data: order_data
    }, status: :ok
  end

  def update
    if %w[completed cancelled].include?(@order.status)
      @order.rating = order_params[:rating] if order_params[:rating].present?
      @order.review = order_params[:review] if order_params[:review].present?
    end

    if order_params[:status] == "cancelled" && !%w[completed cancelled].include?(@order.status)
      @order.status = Order.statuses[:cancelled]
    end

    if @order.save
      render json: {
      code: 200,
      status: "success",
      data: order_data
      }, status: :ok
    else
      render json: {
      code: 422,
      status: "failure",
      error: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user ||= User.find_by(id: Current.session.resource_id)

    unless @user.present?
      render json: {
        code: 404,
        status: "failure",
        error: "User not found."
      }, status: :not_found
    end
  end

  def order_data(order = @order)
    order_details = {
      id: order.id,
      status: order.status,
      total_price: order.total_price.to_s,
      rating: order.rating,
      review: order.review,
      quantity: order.quantity,
      created_at: order.created_at,
      updated_at: order.updated_at
    }

    establishment = order.product.establishment
    order_details[:establishment_details] = {
      id: establishment.id,
      name: establishment.name,
      full_address: establishment.full_address,
      longitude: establishment.longitude,
      latitude: establishment.latitude,
      phone_number: establishment.phone_number
    }

    product = order.product
    order_details[:product_details] = {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price.to_s,
    }
    
    delivery_partner = order.delivery_partner
    return order_details if delivery_partner.nil?

    order_details[:delivery_partner_details] = {
      full_name: delivery_partner.full_name,
      phone_number: delivery_partner.phone_number,
      longitude: delivery_partner.longitude,
      latitude: delivery_partner.latitude
    }

    order_details
  end

  def set_order
    @order ||= Order.find_by(id: params[:id])

    unless @order.present? && @order.user_id == @user.id
      render json: {
        code: 404,
        status: "failure",
        error: "No order found."
      }, status: :not_found
    end
  end

  def create_order_params
   params.require(:order).permit(:product_id, :quantity, :coupon_code)
  end

  def order_params
    params.require(:order).permit(:rating, :review, :status)
  end
end