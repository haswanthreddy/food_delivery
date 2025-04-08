class DeliveryPartnerLocationUpdateService
  def initialize(delivery_partner_id:, coordinate:)
    @delivery_partner_id = delivery_partner_id
    @coordinates = coordinate

    update_location
  end

  def call
    update_location
  end

  private
  attr_reader :delivery_partner_id, :coordinates

  def update_location
    UpdateDeliveryPartnerLocationJob.perform_later(
      delivery_partner_id: delivery_partner_id,
      coordinates: coordinates
    )
  end
end