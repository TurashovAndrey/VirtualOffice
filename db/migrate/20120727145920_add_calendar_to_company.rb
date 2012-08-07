class AddCalendarToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :calendar_id, :integer
  end
end
