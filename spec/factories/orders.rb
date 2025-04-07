FactoryBot.define do
  factory :order do
    association :user
    association :delivery_partner
    association :product
    status { "pending" }
    quantity { rand(1..10) }
    discount_percentage { rand(0..10) }
    review { Faker::Lorem.sentence(word_count: 10) }
    coupon_code { Faker::Alphanumeric.alphanumeric(number: 10) }
    delivered_at { status == 'delivery' ? Time.current + rand(1..10).days : nil }
  end
end
