p "4. Seeding Products"
establishments = Establishment.all

establishments.each do |establishment|


  10.times do
    product = Product.create(
      establishment: establishment,
      name: Faker::Food.dish,
      description: Faker::Lorem.sentence,
      price: Faker::Commerce.price
    )

    Inventory.create(
      product: product,
      establishment: establishment,
      quantity: Faker::Number.between(from: 10, to: 100),
    )
  end
end