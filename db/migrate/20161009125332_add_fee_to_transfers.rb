class AddFeeToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :fee, :decimal, default: 0.0
  end
end
