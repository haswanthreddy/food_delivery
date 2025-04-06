class Establishment < ApplicationRecord
  enum :establishment_type, { restaurant: 0, cafe: 1, bar: 2, bakery: 3, stall: 4 }

  has_many :products, dependent: :destroy
  has_many :inventories, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  validates :email_address,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  with_options presence: true do
    validates :full_address
    validates :city
    validates :phone_number
    validates :establishment_type, inclusion: { in: Establishment.establishment_types.keys }
  end


  validates :latitude, 
    presence: true,
    numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }

  validates :longitude,
    presence: true,
    numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }


  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
