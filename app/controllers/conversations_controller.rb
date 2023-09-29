class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy unread_messages_reset]
  # show chat room with user messages
  def show
    authorize @conversation_sender
    # get conversation of both and get messages
      @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
      @message = Message.new
      @receiver = @conversation_sender.received_user
      @messages = Message.conversation_messages(@conversation_sender.id, @conversation_receiver.id)
  end

  def create
    # Check if the conversation already exists
    existing_conversation = Conversation.find_by(user_id: conversation_params[:user_id], receiver: conversation_params[:receiver])

    if existing_conversation.present?
      redirect_to conversation_path(existing_conversation.id), notice: "He already has a conversation with you"
    else
      # create new conversation for both users
      @conversation_sender = Conversation.new(conversation_params)
      @conversation_receiver = Conversation.new(user_id: conversation_params[:receiver], receiver: conversation_params[:user_id])
      if @conversation_sender.save && @conversation_receiver.save
        redirect_to conversation_path(@conversation_sender), notice: "Conversation room created"
      else
        redirect_to root_path, status: :unprocessable_entity, alert: 'Conversation room not created'
      end
    end
  end


  def destroy
    authorize @conversation_sender
    @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
    ids = [@conversation_sender.id, @conversation_receiver.id]
    # delete conversation via ajax call
    Message.where(conversation_id: ids).delete_all
    if @conversation_receiver.destroy and @conversation_sender.destroy
      #cllback affect dependent destroy, so delete all after conversation deleted
      respond_to do |format|
        format.html { redirect_to root_path(current_user), notice: 'Conversation deleted' }
        format.js
      end
    else
      respond_to do |format|
        format.js { head :unprocessable_entity, warn: 'Conversation not deleted' }
        format.html { redirect_to root_path(current_user), notice: 'Conversation not deleted' }
      end
    end
  end

  def unread_messages_reset
    # reset unread messages
    authorize @conversation_sender
    @conversation_sender.update(unread_messages_count: 0)
    @conversation_receiver = Conversation.where(user_id: @conversation_sender.receiver, receiver: @conversation_sender.user_id).first
    Message.where(conversation_id: @conversation_receiver.id, status: false).update_all(status: true)
    head :ok
  end

  private

  def set_conversation
    begin
      @conversation_sender = Conversation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Record not found' }
        format.js { render js: "alert('Record not found')", status: :unprocessable_entity }
      end
    end
  end
  def conversation_params
    params.require(:conversation).permit(:user_id, :receiver)
  end
end