Establishment.establishment_types.keys.each do |type|
  Establishment.find_or_create_by!(name: "Demo #{type.titleize}") do |est|
    puts "Seeding - Establishment (#{type})"
    
    est.establishment_type = type
    est.full_address = Faker::Address.full_address
    est.city = Faker::Address.city
    est.latitude = Faker::Address.latitude.to_f
    est.longitude = Faker::Address.longitude.to_f
    est.phone_number = Faker::PhoneNumber.phone_number
    est.website = Faker::Internet.url(host: "#{type}.example.com")
    est.email_address = "contact@#{est.name.parameterize}.com"
  end
end