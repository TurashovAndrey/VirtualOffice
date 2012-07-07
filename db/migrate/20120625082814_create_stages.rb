class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :stage_name

      t.timestamps
    end
  end
end
