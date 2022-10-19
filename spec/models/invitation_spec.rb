# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invitation, type: :model do
  describe "Validation" do
    it { should validate_presence_of(:status).with_message(:blank) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:receiver) }
  end

  describe "Validate" do
    context "sender_and_receiver_must_be_different" do
      let(:invitation) { described_class.new }
      let(:sender) { create(:user) }
      let(:receiver) { sender }

      before do
        invitation.sender_id = sender.id
        invitation.receiver_id = receiver.id
        invitation.save
      end

      subject { invitation.errors.full_messages }
      it { is_expected.to include("Receiver must be different from sender") }
    end

    context "duplicate_invitation" do
      let(:invitation) { described_class.new }
      let(:sender) { create(:user) }
      let(:receiver) { create(:user) }

      before do
        create(:invitation, sender: sender, receiver: receiver)
        invitation.sender_id = sender.id
        invitation.receiver_id = receiver.id
        invitation.save
      end

      subject { invitation.errors.full_messages }
      it { is_expected.to include("Receiver already has an invitation") }
    end
  end

  describe "Delegate" do
    it { should delegate_method(:email).to(:sender).with_prefix(true) }
    it { should delegate_method(:full_name).to(:sender).with_prefix(true) }
    it { should delegate_method(:email).to(:receiver).with_prefix(true) }
    it { should delegate_method(:full_name).to(:receiver).with_prefix(true) }
  end
end
