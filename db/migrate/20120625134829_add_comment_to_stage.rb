class AddCommentToStage < ActiveRecord::Migration
  def change
    add_column :stages, :comment_id, :integer
  end
end
