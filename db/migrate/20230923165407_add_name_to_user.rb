class AddNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string, null: false, default: ''
    add_column :users, :last_name, :string, null: false, default: ''
    add_column :users, :about, :string, null: false, default: 'I am a new user'
  end
end
