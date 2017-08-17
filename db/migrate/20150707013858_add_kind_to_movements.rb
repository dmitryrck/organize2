class AddKindToMovements < ActiveRecord::Migration[4.2]
  def change
    add_column :movements, :kind, :string
  end
end
