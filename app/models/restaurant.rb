class Restaurant < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: true }
end
