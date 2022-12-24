class AddCardDetailsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.boolean :card, default: false
      t.decimal :limit
      t.bigint :card_id
    end

    add_foreign_key :accounts, :cards
  end
end
