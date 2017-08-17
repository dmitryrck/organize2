class CreateIncomes < ActiveRecord::Migration[4.2]
  def change
    create_table :incomes do |t|
      t.string :description
      t.decimal :value
      t.boolean :paid, default: false

      t.timestamps null: false
    end
  end
end
