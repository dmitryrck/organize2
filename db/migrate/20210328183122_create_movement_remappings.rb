class CreateMovementRemappings < ActiveRecord::Migration[6.0]
  def change
    create_table :movement_remappings do |t|
      t.boolean :active, null: false, default: true
      t.integer :order, default: 1, null: false
      t.string :kind, null: false
      t.string :field_to_watch, null: false
      t.string :kind_of_match, null: false
      t.string :text_to_match, null: false
      t.string :kind_of_change, null: false
      t.string :field_to_change, null: false
      t.string :text_to_change, null: false

      t.timestamps
    end
  end
end
