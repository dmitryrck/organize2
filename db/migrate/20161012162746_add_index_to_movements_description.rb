class AddIndexToMovementsDescription < ActiveRecord::Migration
  def change
    add_index :movements, :description
  end
end
