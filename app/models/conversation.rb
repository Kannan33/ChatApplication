class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :received_user, class_name: "User", foreign_key: :receiver
  has_many :messages, dependent: :destroy
  validates :user_id, uniqueness: { scope: :receiver }
  validates :receiver, uniqueness: { scope: :user_id }
end
