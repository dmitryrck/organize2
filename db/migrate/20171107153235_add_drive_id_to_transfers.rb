class AddDriveIdToTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :transfers, :drive_id, :string
  end
end
