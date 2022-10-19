# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do
  describe "Validation" do
    it { should validate_presence_of(:name).with_message(:blank) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:tasks) }
  end
end
