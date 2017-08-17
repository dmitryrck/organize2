class AddAccountToMovements < ActiveRecord::Migration[4.2]
  def change
    add_column :movements, :account_id, :integer
    add_index :movements, :account_id
    add_foreign_key :movements, :accounts
  end
end
