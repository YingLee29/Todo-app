# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :category
    association :author, factory: :user
    title { Faker::Hobby.activity }
    status { [0, 1].sample }
    deadline_at { 5.days.from_now }
    priority { %w[low medium high].sample }
    schedule_type { %w[daily weekly monthly].sample }
    start_at { Time.zone.now }
    end_at { 10.days.from_now }
  end
end
