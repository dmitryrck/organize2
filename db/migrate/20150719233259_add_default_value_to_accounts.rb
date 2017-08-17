class AddDefaultValueToAccounts < ActiveRecord::Migration[4.2]
  def change
    change_column :accounts, :start_balance, :decimal, default: 0.0
    change_column :accounts, :current_balance, :decimal, default: 0.0
  end
end
