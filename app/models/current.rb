class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :resource, to: :session, allow_nil: true
end
