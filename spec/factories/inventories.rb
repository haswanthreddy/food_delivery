FactoryBot.define do
  factory :inventory do
    association :establishment
    association :product
    quantity { rand(1..100) }
  end
end
