class RenameInReportsToExpectedMovement < ActiveRecord::Migration[6.0]
  def change
    rename_column :movements, :in_reports, :expected_movement
  end
end
