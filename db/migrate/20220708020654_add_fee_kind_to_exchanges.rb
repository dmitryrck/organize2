class AddFeeKindToExchanges < ActiveRecord::Migration[7.0]
  def change
    add_column :exchanges, :fee_kind, :string, default: "source"
  end
end
