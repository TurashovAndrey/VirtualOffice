class AddExpireDateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :expire_date, :date, :default => "2099-01-01"
  end
end
