class MessagesController < ApplicationController
  # create message with join chat
  def create
    # Check if the conversation exists, return to index path
    conversation = Conversation.find_by(id: params[:conversation_id])
    if conversation.user_id != current_user.id
      raise Pundit::NotAuthorizedError
    end
    # Create and save the message
    @message = conversation.messages.build(message_params.merge conversation_id: conversation.id)
    if @message.save
      redirect_to conversation_path(@message.conversation_id)
    else
      redirect_to conversation_path(@message.conversation_id), alert: 'Message not sent'
    end
  end

  def destroy
    @message = Message.find(params[:id])
    authorize @message
    @message.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end
end