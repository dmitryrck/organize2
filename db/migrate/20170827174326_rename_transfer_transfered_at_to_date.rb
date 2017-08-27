class RenameTransferTransferedAtToDate < ActiveRecord::Migration[5.1]
  def change
    rename_column :transfers, :transfered_at, :date
  end
end
