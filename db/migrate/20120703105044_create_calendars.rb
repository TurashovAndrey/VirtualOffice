class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :calendar_name
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end
