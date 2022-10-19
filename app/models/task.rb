# frozen_string_literal: true

class Task < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :title, presence: true
  validates :deadline_at, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  enum schedule_type: { daily: 0, weekly: 1, monthly: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  has_one_attached :image
  belongs_to :category
  belongs_to :author, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true

  def image_url
    rails_blob_path(image, only_path: true) if image.attached?
  end
end
