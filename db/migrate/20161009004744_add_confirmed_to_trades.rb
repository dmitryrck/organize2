class AddConfirmedToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :confirmed, :boolean, default: false
  end
end
