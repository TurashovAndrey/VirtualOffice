class AddStarttimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_time, :time
  end
end
