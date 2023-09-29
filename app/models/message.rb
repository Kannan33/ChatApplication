class Message < ApplicationRecord

  # associations for user
  belongs_to :conversation
  # validations
  validates :content, presence: true, length: { maximum: 360, too_long: "Content is too long" }

  # associations for user
  scope :conversation_messages,->(user_id, receiver_id) {
    includes(:conversation).references(:conversation_id).where(conversation_id: [user_id, receiver_id]).order(:created_at)
  }

  # update status of user message count, unread message count
  after_commit -> {
    # add send count , receiver count, new message count
    conversation_sender = Conversation.includes(:messages).references(:conversation_id).find(conversation_id)
    conversation_receiver = Conversation.where(user_id: conversation_sender.receiver, receiver: conversation_sender.user_id).take
    count = conversation_sender.messages.count
    conversation_sender.update(send_messages_count: (count > 0) ? count : 0)
    unread_count = conversation_sender.messages.where(status: false).length
    conversation_receiver.update(received_messages_count: (count > 0) ? count : 0, unread_messages_count: unread_count)
  }, on: :create
  after_commit -> {
    conversation_sender = Conversation.includes(:messages).references(:conversation_id).find(conversation_id)
    conversation_receiver = Conversation.where(user_id: conversation_sender.receiver, receiver: conversation_sender.user_id).take
    count = conversation_sender.messages.count
    conversation_sender.update(send_messages_count: (count > 0) ? count : 0)
    unread_count = conversation_sender.messages.where(status: false).length
    # handle user if did not read the message
    conversation_receiver.update(unread_messages_count: unread_count,received_messages_count: (count > 0) ? count : 0)
  }, on: :destroy
end
