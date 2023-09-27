class Conversation < ApplicationRecord
  # associations
  # for get sender and receiver users
  belongs_to :user
  belongs_to :received_user, class_name: "User", foreign_key: :receiver
  # A conversation has many messages
  has_many :messages, dependent: :destroy
  # validates each user has only one conversation to other
  validates :user_id, uniqueness: { scope: :receiver }
  validates :receiver, uniqueness: { scope: :user_id }
end