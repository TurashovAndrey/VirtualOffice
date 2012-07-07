class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.integer :parent_id

      t.timestamps
    end
  end
end
