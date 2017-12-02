class CreateExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_rates do |t|
      t.string :source
      t.string :destination
      t.string :market
      t.decimal :lowest_ask
      t.decimal :highest_bid
      t.decimal :last
      t.timestamps
    end
  end
end
