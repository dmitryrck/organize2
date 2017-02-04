class AddKindToTrades < ActiveRecord::Migration
  def change
    add_column :trades, :kind, :string
    execute %q(update trades set kind = 'Buy';)
  end
end
