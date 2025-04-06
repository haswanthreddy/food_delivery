Restaurant.find_or_create_by(name: "demo restaurant") do |r|
  p "3. Seeding - Restaurant"

  r.full_address = Faker::Address.full_address
  r.city = Faker::Address.city
  r.latitude = Faker::Address.latitude
  r.longitude = Faker::Address.longitude
  r.phone_number = Faker::PhoneNumber.phone_number
  r.website = Faker::Internet.url
end