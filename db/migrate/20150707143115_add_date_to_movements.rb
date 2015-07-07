class AddDateToMovements < ActiveRecord::Migration
  def change
    change_table :movements do |t|
      t.date :paid_at
      t.date :expiry_at
    end
  end
end
