class AddCategoryToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :category, :string
  end
end
