class AddIndexToMovements < ActiveRecord::Migration
  def change
    add_index :movements, :paid
    add_index :movements, :paid_at
  end
end
