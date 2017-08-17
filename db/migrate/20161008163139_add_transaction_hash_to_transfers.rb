class AddTransactionHashToTransfers < ActiveRecord::Migration[4.2]
  def change
    add_column :transfers, :transaction_hash, :string, null: true
    add_index :transfers, :transaction_hash, unique: true
  end
end
