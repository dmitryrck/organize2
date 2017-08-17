class RemoveWrongForeignKeyOnMovements < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :movements, column: :chargeable_id
  end
end
