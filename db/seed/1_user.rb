User.find_or_create_by(email_address: "user@example.com") do |u|
  p "1. Seeding - User"
  
  u.full_name = "demo user"
  u.phone_number = Faker::PhoneNumber.phone_number
  u.password = "password123"
end