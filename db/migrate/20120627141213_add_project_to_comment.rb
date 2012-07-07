class AddProjectToComment < ActiveRecord::Migration
  def change
    add_column :comments, :project_id, :integer
  end
end
