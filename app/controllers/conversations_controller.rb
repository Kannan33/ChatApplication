class ConversationsController < ApplicationController
  # show chat room with user messages
  def show
    #in
    @conversation_sender = Conversation.includes(:received_user).find(params[:id])
    @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
    @message = Message.new
    @receiver = @conversation_sender.received_user
    @messages = Message.conversation_messages(@conversation_sender.id, @conversation_receiver.id)
  end

  def create
    @conversation_sender = Conversation.new(conversation_params)
    @conversation_receiver = Conversation.new(user_id: conversation_params[:receiver], receiver: conversation_params[:user_id])
    if @conversation_sender.save and @conversation_receiver.save
      redirect_to user_conversation_path(current_user, @conversation_sender), notice: "conversation created with #{@conversation_sender.user.name}"
    else
      redirect_to users_path, status: :unprocessable_entity, alert: 'conversation room not created'
    end
  end

  def destroy
    @conversation_sender = Conversation.includes(:received_user).find(params[:id])
    @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
    if @conversation_receiver.destroy and @conversation_sender.destroy
      redirect_to users_path(current_user), notice: "conversations between you and #{@conversation_sender.user.name} deleted"
    else
      redirect_to users_path(current_user), notice: 'something went wrong'
    end
  end

  def unread_messages_reset
    @conversation_sender = Conversation.find(params[:id])
    @conversation_sender.update(unread_messages_count: 0)

    head :ok
  end

  private

  def conversation_params
    params.require(:conversation).permit(:user_id, :receiver)
  end
end