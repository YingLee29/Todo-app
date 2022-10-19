# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task, type: :model do
  describe "Validation" do
    it { should validate_presence_of(:title).with_message(:blank) }
    it { should validate_presence_of(:deadline_at).with_message(:blank) }
    it { should validate_presence_of(:start_at).with_message(:blank) }
    it { should validate_presence_of(:end_at).with_message(:blank) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:category) }
  end
end
