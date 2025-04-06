FactoryBot.define do
  factory :establishment do
    name { Faker::Restaurant.name }
    full_address { Faker::Address.full_address }
    city { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    phone_number { Faker::PhoneNumber.phone_number }
    email_address { Faker::Internet.email }
    establishment_type { Establishment.establishment_types.keys.sample }
  end
end
