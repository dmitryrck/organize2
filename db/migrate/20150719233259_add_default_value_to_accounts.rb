class AddDefaultValueToAccounts < ActiveRecord::Migration
  def change
    change_column :accounts, :start_balance, :decimal, default: 0.0
    change_column :accounts, :current_balance, :decimal, default: 0.0
  end
end
