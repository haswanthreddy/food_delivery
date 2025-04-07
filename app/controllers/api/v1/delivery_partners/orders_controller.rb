class Api::V1::DeliveryPartners::OrdersController < ApplicationController
  before_action :require_authentication
  before_action :set_delivery_partner
  before_action :set_order

  def show
    render json: {
      code: 200,
      status: "success",
      data: order_data
    }, status: :ok
  end

  def accept
    return render_error("Order already accepted", :unprocessable_entity, 422) if @order.delivery_partner_id.present?
    
    @order.delivery_partner = @delivery_partner
    
    if @order.save
      render json: {
        code: 200,
        status: "success",
        data: order_data
      }, status: :ok
    else
      render_error(@order.errors.full_messages)
    end
  end

  def update
    if @order.update(order_params)
      render json: {
        code: 200,
        status: "success",
        data: order_data
      }, status: :ok
    else
      render_error(@order.errors.full_messages, :unprocessable_entity, 422)
    end
  end

  private 

  def order_data
    order_data = {
      id: @order.id,
      status: @order.status,
      total_price: @order.total_price.to_s
    }
    
    establishment = @order.product.establishment
    order_data[:establishment_details] = {
      name: establishment.name,
      full_address: establishment.full_address,
      longitude: establishment.longitude,
      latitude: establishment.latitude,
      phone_number: establishment.phone_number
    }
    
    user = @order.user
    order_data[:user_details] = {
      full_name: user.full_name,
      phone_number: user.phone_number,
      longitude: user.longitude,
      latitude: user.latitude
    }
    
    product = @order.product
    order_data[:product_details] = {
      name: product.name,
      description: product.description,
      price: product.price.to_s,
    }

    order_data
  end

  def set_delivery_partner
    @delivery_partner ||= DeliveryPartner.find_by(id: Current.session.resource_id)

    unless @delivery_partner.present?
      render_error("Delivery partner not found", :not_found, 404)
    end
  end

  def set_order
    @order = Order.find_by(id: params[:id])

    unless @order.present? && (action_name == "accept" || @order.delivery_partner_id == @delivery_partner.id)
      render_error("Order not found", :not_found, 404)
    end
  end

  def order_params
    params.require(:order).permit(:status)
  end

  def render_error(message, status = :unprocessable_entity, code = 422)
    render json: {
      code: code,
      status: "failure",
      error: message
    }, status: status
  end
end