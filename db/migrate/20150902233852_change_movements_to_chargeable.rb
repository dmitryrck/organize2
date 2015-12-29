class ChangeMovementsToChargeable < ActiveRecord::Migration
  def up
    add_column :movements, :chargeable_type, :string
    rename_column :movements, :account_id, :chargeable_id
    execute %q(update movements set chargeable_type = 'Account';)
  end

  def down
    rename_column :movements, :chargeable_id, :account_id
    remove_column :movements, :chargeable_type
  end
end
