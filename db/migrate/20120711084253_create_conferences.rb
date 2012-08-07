class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.integer :room_id
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
