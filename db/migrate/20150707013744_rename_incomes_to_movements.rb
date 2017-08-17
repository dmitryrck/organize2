class RenameIncomesToMovements < ActiveRecord::Migration[4.2]
  def change
    rename_table :incomes, :movements
  end
end
