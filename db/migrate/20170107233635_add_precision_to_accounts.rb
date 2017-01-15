class AddPrecisionToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :precision, :integer, default: 2
  end
end
