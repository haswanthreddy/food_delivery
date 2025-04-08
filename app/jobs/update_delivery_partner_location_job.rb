class UpdateDeliveryPartnerLocationJob < ApplicationJob
  queue_as :default

  def perform(delivery_partner_id:, coordinates:)
    p "working ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    Rails.logger.info "Updating location for Delivery Partner ID: #{delivery_partner_id} with coordinates: #{coordinates}"
  end
end
