class AddDriveIdToMovements < ActiveRecord::Migration[5.1]
  def change
    add_column :movements, :drive_id, :string
  end
end
