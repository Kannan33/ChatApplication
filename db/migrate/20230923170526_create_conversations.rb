class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :receiver, null: false
      t.integer :send_messages_count, null: false, default: 0
      t.integer :received_messages_count, null: false, default: 0
      t.integer :unread_messages_count, null: false, default: 0

      t.timestamps
    end
  end
end
