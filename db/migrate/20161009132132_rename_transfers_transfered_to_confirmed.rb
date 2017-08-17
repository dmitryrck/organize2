class RenameTransfersTransferedToConfirmed < ActiveRecord::Migration[4.2]
  def change
    rename_column :transfers, :transfered, :confirmed
  end
end
