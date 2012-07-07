class AddDefaultGroupToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :default_group, :integer
  end
end
