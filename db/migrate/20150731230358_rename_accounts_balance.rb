class RenameAccountsBalance < ActiveRecord::Migration[4.2]
  def change
    rename_column :accounts, :current_balance, :balance
  end
end
