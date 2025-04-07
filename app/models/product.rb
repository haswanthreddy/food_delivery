class Product < ApplicationRecord
  belongs_to :establishment
  has_one :inventory, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :establishment_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :rating, inclusion: { in: 0..5, message: "must be between 0 and 5" }
end
