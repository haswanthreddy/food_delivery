p "6. seeding orders"

DeliveryPartner.all.each do |delivery_partner|
  10.times do
    order = Order.create!(
      user: User.all.sample,
      product: Product.all.sample,
      delivery_partner: delivery_partner,
      quantity: Faker::Number.between(from: 1, to: 5),
      status: ["completed", "cancelled"].sample,
    )
  end
end

delivery_partner = DeliveryPartner.last
user = User.first
product = Product.first

order = Order.create!(
  user: user,
  product: product,
  delivery_partner: delivery_partner,
  quantity: 1
)