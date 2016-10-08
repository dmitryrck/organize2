class AddTransactionHashToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :transaction_hash, :string, null: true
    add_index :transfers, :transaction_hash, unique: true
  end
end
