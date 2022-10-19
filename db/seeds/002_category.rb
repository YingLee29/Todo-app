# frozen_string_literal: true

5.times do |n|
  Category.create!(
    name: "Category_#{n}"
  )
end
