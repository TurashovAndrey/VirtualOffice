class CreateTaskAttachments < ActiveRecord::Migration
  def change
    create_table :task_attachments do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end
