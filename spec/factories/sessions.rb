FactoryBot.define do
  factory :session do
    ip_address { Faker::Internet.ip_v4_address }
    user_agent { "browser" }

    trait :for_user do
      association :resource, factory: :user
    end

    trait :for_delivery_partner do
      association :resource, factory: :delivery_partner
    end

    initialize_with { new(attributes) }
  end
end