class AddStageToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :stage_id, :integer
  end
end
