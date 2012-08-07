class AddStageToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :stage_id, :integer
  end
end
