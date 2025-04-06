class Inventory < ApplicationRecord
  belongs_to :establishment
  belongs_to :product

  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :establishment_id, presence: true, uniqueness: { scope: :product_id, message: "Combination with product must be unique" }
end
