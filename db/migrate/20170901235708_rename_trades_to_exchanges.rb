class RenameTradesToExchanges < ActiveRecord::Migration[5.1]
  def change
    rename_table :trades, :exchanges
    rename_column :exchanges, :trade_at, :date
  end
end
