class AddCurrencyToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :currency, :string
    add_index :accounts, :currency
  end
end
