class RenameMovementsPaidAtToDate < ActiveRecord::Migration[5.1]
  def change
    rename_column :movements, :paid_at, :date
  end
end
