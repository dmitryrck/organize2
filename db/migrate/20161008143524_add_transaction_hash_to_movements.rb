class AddTransactionHashToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :transaction_hash, :string, null: true
    add_index :movements, [:transaction_hash, :chargeable_type, :chargeable_id],
      name: 'index_movements_on_transaction_hash', unique: true
  end
end
