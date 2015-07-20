class RemoveExpiresAtFromMovements < ActiveRecord::Migration
  def change
    remove_column :movements, :expires_at
  end
end
