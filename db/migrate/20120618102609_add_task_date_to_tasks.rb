class AddTaskDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_date, :datetime
  end
end
