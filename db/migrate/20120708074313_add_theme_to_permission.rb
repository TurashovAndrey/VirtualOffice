class AddThemeToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :theme_id, :integer
  end
end
