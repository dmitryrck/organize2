class AddCurrencyToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :currency, :string
  end
end
