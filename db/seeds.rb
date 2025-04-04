if Rails.env.development?
  Dir[Rails.root.join("db/seed/*.rb")].sort.each do |seed|
    load seed
  end
end