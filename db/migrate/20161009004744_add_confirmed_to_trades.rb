class AddConfirmedToTrades < ActiveRecord::Migration[4.2]
  def change
    add_column :trades, :confirmed, :boolean, default: false
  end
end
