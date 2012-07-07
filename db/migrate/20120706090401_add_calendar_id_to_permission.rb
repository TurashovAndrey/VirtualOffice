class AddCalendarIdToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :calendar_id, :integer
  end
end
