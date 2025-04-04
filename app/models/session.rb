class Session < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
