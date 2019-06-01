class AddInReportsToMovements < ActiveRecord::Migration[5.2]
  def change
    add_column :movements, :in_reports, :boolean, default: true
  end
end
