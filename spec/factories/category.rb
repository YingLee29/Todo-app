# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "category_#{n}" }
  end
end
