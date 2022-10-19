# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :status, presence: true, inclusion: { in: %w[waiting rejected accepted] }

  validate :sender_and_receiver_must_be_different, if: -> { receiver_id.present? }, on: :create
  validate :duplicate_invitation, if: -> { receiver_id.present? }, on: :create

  enum status: { waiting: 0, rejected: 1, accepted: 2 }

  delegate :email, :full_name, to: :sender, prefix: true
  delegate :email, :full_name, to: :receiver, prefix: true

  def sender_and_receiver_must_be_different
    errors.add(:receiver, "must be different from sender") if sender_id == receiver_id
  end

  def duplicate_invitation
    if Invitation.exists?(sender_id: sender_id,
                          receiver_id: receiver_id) || Invitation.exists?(sender_id: receiver_id,
                                                                          receiver_id: sender_id)
      errors.add(:receiver, "already has an invitation")
    end
  end
end
