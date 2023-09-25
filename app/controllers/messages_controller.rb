class MessagesController < ApplicationController

  # create message with join chat
  def create
    # set chat id with sender and receiver ids
    @message = Message.new(message_params)
    if @message.save
      redirect_to user_conversation_path(current_user.id, @message.conversation_id), notice: 'message sent'
    else
      redirect_to user_conversation_path(current_user.id, @message.conversation_id), alert: 'message not sent'
    end
  end


  # delete message only if user not viewed
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to user_conversation_path(current_user.id, @message.conversation_id), notice: 'message deleted'
  end

  private

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end
end