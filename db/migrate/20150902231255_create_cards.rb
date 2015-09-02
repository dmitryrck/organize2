class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.decimal :limit, default: 0.0
      t.integer :payment_day

      t.timestamps
    end
  end
end
