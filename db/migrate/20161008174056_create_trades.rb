class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.references :source
      t.references :destination

      t.decimal :value_in, default: 0.0
      t.decimal :value_out, default: 0.0
      t.decimal :fee, default: 0.0
      t.date :trade_at
      t.string :transaction_hash, null: true

      t.timestamps null: false
    end

    add_index :trades, :source_id
    add_index :trades, :destination_id

    add_index :trades, :transaction_hash, unique: true

    add_foreign_key :trades, :accounts, column: :source_id
    add_foreign_key :trades, :accounts, column: :destination_id
  end
end
