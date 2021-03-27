class AddPaidToToMovements < ActiveRecord::Migration[6.0]
  def up
    add_column :movements, :paid_to, :string
  end
end
