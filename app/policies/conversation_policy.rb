class ConversationPolicy
  attr_reader :user, :conversation

  def initialize(user, conversation)
    @user = user
    @conversation_sender = conversation
  end
  # check if the user is the url sender and conversation is belong to the user
  def show?
    @conversation_sender.user_id == @user.id
  end

  def destroy?
    @conversation_sender.user_id == @user.id
  end

  def unread_messages_reset?
    @conversation_sender.user_id == @user.id
  end
end