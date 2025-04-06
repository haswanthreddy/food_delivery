DeliveryPartner.find_or_create_by(email_address: "delivery_partner@example.com") do |d|
  p "2. Seeding - Delivery Partner"

  d.full_name = "demo delivery partner"
  d.phone_number = Faker::PhoneNumber.phone_number
  d.verified = true
  d.full_address = Faker::Address.full_address
  d.latitude = Faker::Address.latitude
  d.longitude = Faker::Address.longitude
  d.password = "password123"
  d.city = Faker::Address.city
end