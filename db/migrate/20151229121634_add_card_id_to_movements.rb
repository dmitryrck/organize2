class AddCardIdToMovements < ActiveRecord::Migration[4.2]
  def change
    add_column :movements, :card_id, :integer
    add_foreign_key :movements, :cards
    add_index :movements, :card_id
  end
end
