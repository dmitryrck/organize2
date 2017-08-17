class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :start_balance
      t.decimal :current_balance

      t.timestamps null: false
    end
  end
end
