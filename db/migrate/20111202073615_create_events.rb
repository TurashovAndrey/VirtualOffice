class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :color
      t.integer :user_id
      t.integer :company_id

      t.date :start_at
      t.date :end_at

      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
