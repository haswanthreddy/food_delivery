class User < ApplicationRecord
  has_secure_password
  has_many :sessions, as: :resource, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
