class Product < ApplicationRecord
  belongs_to :establishment
  has_many :inventories, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :establishment_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
