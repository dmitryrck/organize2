class AddPrecisionToCards < ActiveRecord::Migration[4.2]
  def change
    add_column :cards, :precision, :integer, default: 2
  end
end
