class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_one_attached :avatar, dependent: :destroy
  scope :except_this, ->(user_ids) {
    where.not(id: user_ids)
  }
  # users_not_in_conversations = User.where.not(id: conversation_user_ids).where.not(id: current_user_id)
  # has_many :conversations, dependent: :destroy, foreign_key: :user_id
  # has_many :reserved_conversations, class_name: "Conversation", foreign_key: :receiver
  has_many :conversations, dependent: :destroy, foreign_key: :user_id
  has_many :received_conversations, class_name: "Conversation", foreign_key: :receiver
  validates :first_name, :last_name, presence: true, :if => :validate_only_alphabet

  private
  # only alphabets are allowed
  def validate_only_alphabet
    if !self.first_name.match?(/^[A-Za-z]+$/)
      errors.add(:first_name, "only alphabets are allowed")
      false
    elsif !self.last_name.match?(/^[A-Za-z]+$/)
      errors.add(:last_name, "only alphabets are allowed")
      false
    else
      true
    end
  end
end
