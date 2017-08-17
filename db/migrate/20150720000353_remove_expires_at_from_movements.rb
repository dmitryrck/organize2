class RemoveExpiresAtFromMovements < ActiveRecord::Migration[4.2]
  def change
    remove_column :movements, :expires_at
  end
end
