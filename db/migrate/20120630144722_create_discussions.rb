class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :theme_id
      t.string :discussion

      t.timestamps
    end
  end
end
