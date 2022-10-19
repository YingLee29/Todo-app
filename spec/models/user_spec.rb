# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "Validation" do
    it { should validate_presence_of(:password).with_message(:blank) }
    it { should validate_presence_of(:email).with_message(:blank) }
    it { should validate_presence_of(:full_name).with_message(:blank) }

    it { should validate_length_of(:password).is_at_least(8).with_message(:too_short) }
    it { should validate_length_of(:password).is_at_most(255).with_message(:too_long) }
    it { should validate_length_of(:email).is_at_most(255).with_message(:too_long) }
    it { should validate_length_of(:full_name).is_at_most(255).with_message(:too_long) }
  end

  describe "Associations" do
    it { is_expected.to have_many(:invitations) }
    it { is_expected.to have_many(:received_invitations) }
  end

  describe "linked_invitations" do
    let(:user) { create(:user) }
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:invitation) { create(:invitation, sender: user, receiver: user_1, status: :accepted) }
    let(:invitation_1) { create(:invitation, sender: user_2, receiver: user, status: :accepted) }

    before do
      invitation
      invitation_1
    end

    subject { user.linked_invitations.length }
    it { is_expected.to eq(2) }
  end
end
