class CreateCompanies < ActiveRecord::Migration
  def up
    create_table :companies do |t|
      t.string :name, :null => false, :default => ''
      t.string :url_base,  :null => false, :default => ''
    end
  end

  def down
    drop_table :companies
  end
end
