class Message < ApplicationRecord

  # associations for user
  belongs_to :conversation
  # validations for user
  validates :content, presence: true, length: { maximum: 255 }

  # associations for user
  scope :conversation_messages,->(user_id, receiver_id) {
    includes(:conversation).references(:conversation_id).where(conversation_id: [user_id, receiver_id]).order(:created_at)
  }

  # update status of user message count, unread message count
  after_create -> {
    # add send count , receiver count, new message count
    conversation_sender = Conversation.find(conversation_id)
    conversation_sender.update(send_messages_count: conversation_sender.send_messages_count+1)
    conversation_receiver = Conversation.where(user_id: conversation_sender.receiver, receiver: conversation_sender.user_id).take
    conversation_receiver.update(unread_messages_count: conversation_receiver.unread_messages_count+1, received_messages_count: conversation_receiver.received_messages_count+1)
  }

  # # I can remove this callback to make dependent destroy work as bulk destroy
  # after_destroy -> {
  # add send count , receiver count, new message count
  # conversation_sender = Conversation.find(conversation_id)
  # conversation_sender.update(send_messages_count: conversation_sender.send_messages_count-1)
  # conversation_receiver = Conversation.where(user_id: conversation_sender.receiver, receiver: conversation_sender.user_id).take
  # count = conversation_receiver.unread_messages_count
  # if count != 0
  #   count = count-1
  # end
  # conversation_receiver.update(unread_messages_count: count, received_message_count: conversation_receiver.received_messages_count-1)
  # }

end
