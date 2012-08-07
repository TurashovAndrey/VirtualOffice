class AddSetChatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :set_chat, :boolean, :default => false
  end
end
