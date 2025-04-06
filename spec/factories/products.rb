FactoryBot.define do
  factory :product do
    association :establishment
    name { Faker::Food.dish }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 0..999.99) }
  end
end
