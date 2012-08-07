class AddOwnerToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :owner_id, :integer
  end
end
