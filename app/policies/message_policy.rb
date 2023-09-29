class MessagePolicy < ApplicationPolicy
  attr_reader :user, :message

  def initialize(user, message)
    @user = user
    @message = message
  end

  def destroy?
    @user.id == @message.conversation.user_id
  end
end