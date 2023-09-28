class ConversationsController < ApplicationController
  # show chat room with user messages
  def show
    # get conversation of both and get messages
    begin
      @conversation_sender = Conversation.includes(:received_user).find(params[:id])
      @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
      @message = Message.new
      @receiver = @conversation_sender.received_user
      @messages = Message.conversation_messages(@conversation_sender.id, @conversation_receiver.id)
    rescue ActiveRecord::RecordNotFound
      record_not_found
      return
    end
  end

  def create
    # Check if the conversation already exists
    existing_conversation = Conversation.find_by(user_id: conversation_params[:user_id], receiver: conversation_params[:receiver])

    if existing_conversation.present?
      redirect_to user_conversation_path(current_user, existing_conversation.id), notice: "He already has a conversation with you"
    else
      # create new conversation for both users
      @conversation_sender = Conversation.new(conversation_params)
      @conversation_receiver = Conversation.new(user_id: conversation_params[:receiver], receiver: conversation_params[:user_id])

      if @conversation_sender.save && @conversation_receiver.save
        redirect_to user_conversation_path(current_user, @conversation_sender), notice: "Conversation room created"
      else
        redirect_to users_path, status: :unprocessable_entity, alert: 'Conversation room not created'
      end
    end
  end


  def destroy
    # Check if the conversation exists
    begin
      @conversation_sender = Conversation.find(params[:id])
      @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
    rescue ActiveRecord::RecordNotFound
      record_not_found
    end
    # delete conversation via ajax call
    if @conversation_receiver.destroy and @conversation_sender.destroy
      respond_to do |format|
        format.html { redirect_to users_path(current_user), notice: 'Conversation deleted' }
        format.js
      end
    else
      respond_to do |format|
        format.js { head :unprocessable_entity, warn: 'Conversation not deleted' }
        format.html { redirect_to users_path(current_user), notice: 'Conversation not deleted' }
      end
    end
  end

  def unread_messages_reset
    # reset unread messages
    @conversation_sender = Conversation.find(params[:id])
    @conversation_sender.update(unread_messages_count: 0)

    head :ok
  end

  private
  def conversation_params
    params.require(:conversation).permit(:user_id, :receiver)
  end

  def record_not_found
    respond_to do |format|
      flash[:warn] = 'Record not found'
      format.html { redirect_to users_path }
      format.js { render js: "alert('Record not found')", status: :unprocessable_entity }
    end
  end
end