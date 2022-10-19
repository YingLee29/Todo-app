# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8, maximum: 255 }, format: { with: VALID_PASSWORD_REGEX },
                       allow_blank: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :full_name, presence: true, length: { maximum: 255 }

  has_many :author_tasks, foreign_key: "author_id", class_name: "Task"
  has_many :assignee_tasks, foreign_key: "assignee_id", class_name: "Task"
  has_many :invitations, foreign_key: "sender_id", class_name: "Invitation"
  has_many :received_invitations, foreign_key: "receiver_id", class_name: "Invitation"

  def linked_invitations
    invitations.accepted + received_invitations.accepted
  end
end
