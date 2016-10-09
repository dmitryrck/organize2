class RenameTransfersTransferedToConfirmed < ActiveRecord::Migration
  def change
    rename_column :transfers, :transfered, :confirmed
  end
end
