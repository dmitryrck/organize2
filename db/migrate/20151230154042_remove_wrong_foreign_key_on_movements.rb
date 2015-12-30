class RemoveWrongForeignKeyOnMovements < ActiveRecord::Migration
  def change
    remove_foreign_key :movements, column: :chargeable_id
  end
end
