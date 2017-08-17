class AddCurrencyToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :currency, :string
    add_index :accounts, :currency
  end
end
