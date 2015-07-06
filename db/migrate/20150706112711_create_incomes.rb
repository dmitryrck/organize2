class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.string :description
      t.decimal :value
      t.boolean :paid, default: false

      t.timestamps null: false
    end
  end
end
