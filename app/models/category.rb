# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :tasks
  validates :name, presence: true
end
