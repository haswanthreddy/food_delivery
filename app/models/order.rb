class Order < ApplicationRecord
  belongs_to :user
  belongs_to :delivery_partner, optional: true
  belongs_to :product

  enum :status, { pending: 0, assigned_delivery_partner: 1, out_for_delivery: 2, completed: 3, cancelled: 4 }

  validates :status, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :discount_percentage, inclusion: { in: 0..100 }
  validates :rating, inclusion: { in: 0..5, message: "must be between 0 and 5" }
  validates :review, length: { maximum: 500 }, allow_nil: true
  validate :inventory_available

  after_commit :reduce_inventory, on: :create

  before_update :status_change_allowed?, if: :should_validate_status_change?
  before_update :delivery_partner_assignment_status_update, if: :will_save_change_to_delivery_partner_id?

  def total_price
    product.price * quantity * ((100 - discount_percentage) / 100.0)
  end

  private

  def inventory_available
    return unless product&.inventory

    if product.inventory.quantity < quantity
      errors.add(:base, "Insufficient inventory")
    end
  end

  def reduce_inventory
    return unless product&.inventory

    if product.inventory.quantity > 0
      product.inventory.decrement!(:quantity, quantity)
    else
      errors.add(:base, "Product inventory is not available")
    end
  end

  def delivery_partner_assignment_status_update
    self.status = :assigned_delivery_partner if delivery_partner_id.present?
  end

  def status_change_allowed?
    errors.add(:status, "cannot be changed from pending to the selected status as delivery partner is not assigned")
    throw(:abort)
  end

  def should_validate_status_change?
    will_save_change_to_status? && delivery_partner_id.nil?
  end
end
