class AddStageToComment < ActiveRecord::Migration
  def change
    add_column :comments, :stage_id, :integer
  end
end
