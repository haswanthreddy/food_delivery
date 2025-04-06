FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email_address { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    city { Faker::Address.city }
    password { "password123" }
  end
end