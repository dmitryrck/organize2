class AddCategoryToMovements < ActiveRecord::Migration[4.2]
  def change
    add_column :movements, :category, :string
  end
end
