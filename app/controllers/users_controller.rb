class UsersController < ApplicationController

  # Show all user chat with and chat option
  def index
    # only conversations made by current user
    # get users, if they already created conversations with another user with that user
    @conversations = Conversation.includes(:received_user).where(user_id: current_user.id)

    # new conversations, they are not conversations with current user
    user_ids = current_user.conversations.pluck(:receiver)
    user_ids << current_user.id
    @users = User.except_this(user_ids)

  end

  # show user profile
  def profile
    # if user search another user or view his profile
    # if user search another user and user try to self search it go his profile
    @receiver = User.find_by(email: params[:email])
    # if user search user not present go back to root
    if  @receiver == nil
      redirect_to root_path, notice: 'User not exist'
    elsif @receiver&.email == current_user.email
      # if user request to view his profile
      render :profile
    else
      # if user's search user present
      @search_user_conversations = Conversation.includes(:received_user).where(user_id: @receiver.id)
      render :profile
    end
  end
end