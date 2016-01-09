class AddFeeToMovements < ActiveRecord::Migration
  def change
    change_table :movements do |t|
      t.decimal :fee, default: 0.0, precision: 15, scale: 10
      t.string :fee_kind
    end
  end
end
