class AddDescriptionToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :description, :string
  end
end
