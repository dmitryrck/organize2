class CreateTransfers < ActiveRecord::Migration[4.2]
  def change
    create_table :transfers do |t|
      t.integer :source_id
      t.integer :destination_id
      t.decimal :value
      t.boolean :transfered, default: false
      t.date :transfered_at

      t.timestamps
    end
  end
end
