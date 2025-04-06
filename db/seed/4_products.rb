p "4. Seeding Products"
establishments = Establishments.all

establishments.each do |establishment|


  10.times do
    product = Product.create(
      establishment: establishment,
      name: Faker::Food.dish,
      description: Faker::Lorem.sentence,
      price: Faker::Commerce.price
    )
  end
end