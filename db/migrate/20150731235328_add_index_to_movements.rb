class AddIndexToMovements < ActiveRecord::Migration[4.2]
  def change
    add_index :movements, :paid
    add_index :movements, :paid_at
  end
end
