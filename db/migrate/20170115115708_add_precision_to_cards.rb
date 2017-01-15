class AddPrecisionToCards < ActiveRecord::Migration
  def change
    add_column :cards, :precision, :integer, default: 2
  end
end
