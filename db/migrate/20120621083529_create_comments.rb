class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :company_id
      t.string :comment
      t.datetime :comment_date

      t.timestamps
    end
  end
end
