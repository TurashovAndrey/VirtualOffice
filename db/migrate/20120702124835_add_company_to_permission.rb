class AddCompanyToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :company_id, :integer
  end
end
