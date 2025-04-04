FactoryBot.define do
  factory :delivery_partner do
    full_name { Faker::Name.name }
    email_address { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    password { "password123" }
  end
end
