class AddTaskToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :task_id, :integer
  end
end
