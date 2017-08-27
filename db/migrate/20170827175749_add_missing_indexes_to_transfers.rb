class AddMissingIndexesToTransfers < ActiveRecord::Migration[5.1]
  def change
    add_index :transfers, :source_id
    add_index :transfers, :destination_id
    add_index :transfers, :value
    add_index :transfers, :confirmed
    add_index :transfers, :date
    add_index :transfers, :fee

    add_foreign_key :transfers, :accounts, column: :source_id
    add_foreign_key :transfers, :accounts, column: :destination_id
  end
end
