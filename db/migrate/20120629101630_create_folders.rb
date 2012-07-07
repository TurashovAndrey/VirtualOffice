class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :folder_name

      t.timestamps
    end
  end
end
