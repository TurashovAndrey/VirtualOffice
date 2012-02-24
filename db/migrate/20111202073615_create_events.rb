class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :color
      t.integer :user_id
      t.integer :company_id

      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
