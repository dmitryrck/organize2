class AddActiveToCards < ActiveRecord::Migration[4.2]
  def change
    add_column :cards, :active, :boolean, default: true
  end
end
