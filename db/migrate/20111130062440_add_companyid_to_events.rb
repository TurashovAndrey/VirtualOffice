class AddCompanyidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :company_id, :integer
  end
end
