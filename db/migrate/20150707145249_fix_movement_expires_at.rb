class FixMovementExpiresAt < ActiveRecord::Migration[4.2]
  def change
    rename_column :movements, :expiry_at, :expires_at
  end
end
