class AddPrecisionToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :precision, :integer, default: 2
  end
end
