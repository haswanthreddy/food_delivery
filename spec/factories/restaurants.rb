FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    full_address { Faker::Address.full_address }
    city { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    phone_number { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.url(host: 'example.com') }
  end
end