class RenameMovementsPaidToConfirmed < ActiveRecord::Migration[5.1]
  def change
    rename_column :movements, :paid, :confirmed
  end
end
