Establishment.all.each do |establishment|
  establishment.products.each do |product|
    Inventory.create(
      establishment: establishment,
      product: product,
      quantity: rand(1..100)
    )
  end
end