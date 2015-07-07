class FixMovementExpiresAt < ActiveRecord::Migration
  def change
    rename_column :movements, :expiry_at, :expires_at
  end
end
