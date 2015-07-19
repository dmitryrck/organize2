class AddAccountToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :account_id, :integer
    add_index :movements, :account_id
    add_foreign_key :movements, :accounts
  end
end
