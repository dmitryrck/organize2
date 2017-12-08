class AddDriveIdToExchanges < ActiveRecord::Migration[5.1]
  def change
    add_column :exchanges, :drive_id, :string
  end
end
