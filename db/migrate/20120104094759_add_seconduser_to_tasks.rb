class AddSeconduserToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :second_user_id, :integer
  end
end
