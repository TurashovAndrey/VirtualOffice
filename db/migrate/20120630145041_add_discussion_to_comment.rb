class AddDiscussionToComment < ActiveRecord::Migration
  def change
    add_column :comments, :discussion_id, :integer
  end
end
