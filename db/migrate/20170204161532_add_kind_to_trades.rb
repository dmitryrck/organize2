class AddKindToTrades < ActiveRecord::Migration[4.2]
  def change
    add_column :trades, :kind, :string
    execute %q(update trades set kind = 'Buy';)
  end
end
