# frozen_string_literal: true

5.times do |_n|
  User.create!(
    email: Faker::Internet.email,
    password: "password",
    full_name: Faker::Name.name
  )
end
