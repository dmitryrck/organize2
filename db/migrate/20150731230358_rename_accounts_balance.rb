class RenameAccountsBalance < ActiveRecord::Migration
  def change
    rename_column :accounts, :current_balance, :balance
  end
end
