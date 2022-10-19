# frozen_string_literal: true

IMAGES = Dir[Rails.public_path.join("images/tasks/*")]
STATUS = [0, 1].freeze

Category.all.each do |category|
  5.times do
    task = Task.create!(
      title: Faker::Hobby.activity,
      status: STATUS.sample,
      start_at: Time.zone.now,
      end_at: 5.hours.from_now,
      deadline_at: 5.days.from_now,
      author_id: User.pluck(:id).sample,
      assignee_id: nil,
      category_id: category.id,
      priority: rand(0..2)
    )
    image = IMAGES.sample
    task.image.attach(io: File.open(image), filename: File.basename(image))
  end
end
