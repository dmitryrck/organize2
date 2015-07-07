class RenameIncomesToMovements < ActiveRecord::Migration
  def change
    rename_table :incomes, :movements
  end
end
