class AddFeeToTransfers < ActiveRecord::Migration[4.2]
  def change
    add_column :transfers, :fee, :decimal, default: 0.0
  end
end
