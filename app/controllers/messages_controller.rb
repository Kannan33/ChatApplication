class MessagesController < ApplicationController

  # create message with join chat
  def create
    # Check if the conversation exists, return to index path
    conversation = Conversation.find_by(id: message_params[:conversation_id])

    if conversation.nil?
      redirect_to users_path
      flash[:warn] = 'Your conversation deleted by your receiver'
    else
      # Create and save the message
      @message = conversation.messages.build(message_params)
      if @message.save
        redirect_to user_conversation_path(current_user.id, @message.conversation_id)
      else
        redirect_to user_conversation_path(current_user.id, @message.conversation_id), alert: 'Message not sent'
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end
end