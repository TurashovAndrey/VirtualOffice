class AddCompanyToConference < ActiveRecord::Migration
  def change
    add_column :conferences, :company_id, :integer
  end
end
