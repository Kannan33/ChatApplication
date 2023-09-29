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
  def search_profile
    # if user search another user or view his profile
    @user_profile = User.find_by(email: params[:email]&.strip)
    if  @user_profile.present? and @user_profile.eql? current_user
      # if user request to his own profile
      @search_user_conversations = Conversation.includes(:received_user).where(user_id: @user_profile.id)
      render :profile
    elsif @user_profile.present?
      # if user's search user present
      @search_user_conversations = Conversation.includes(:received_user).where(user_id: @user_profile.id)
      @user_profile
      render :profile
    else
      # # if user search user not present go back to root
      redirect_to root_path, notice: 'User not exist'
    end
  end
  def profile
    # this action handle both routes users/1/profile -> current user profile and users/1/profile/id -> this for ajax
    # current user profile
    if params[:id]&.present?
      @user_profile = User.find(params[:id])
    else
      @user_profile = current_user
    end
    @search_user_conversations = Conversation.includes(:received_user).where(user_id: @user_profile.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def manage_users
    # this action takes all conversations of users and show them
    @current_conversations = Conversation.includes(:received_user).where(user_id: current_user.id)
    render :manage_users
  end
end