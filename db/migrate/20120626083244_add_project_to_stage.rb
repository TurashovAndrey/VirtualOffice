class AddProjectToStage < ActiveRecord::Migration
  def change
    add_column :stages, :project_id, :integer
  end
end
