p "2. Seeding - Delivery Partner"

DeliveryPartner.find_or_create_by(email_address: "delivery_partner@example.com") do |d|
  d.full_name = "demo delivery partner"
  u.phone_number = Faker::PhoneNumber.phone_number
  u.verified = true
  u.full_address = Faker::Address.full_address
  u.latitude = Faker::Address.latitude
  u.longitude = Faker::Address.longitude
  u.password = "password123"
end