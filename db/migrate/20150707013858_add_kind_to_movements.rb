class AddKindToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :kind, :string
  end
end
