class AddActiveToCards < ActiveRecord::Migration
  def change
    add_column :cards, :active, :boolean, default: true
  end
end
