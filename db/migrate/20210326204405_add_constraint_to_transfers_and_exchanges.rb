class AddConstraintToTransfersAndExchanges < ActiveRecord::Migration[6.0]
  def change
    execute %[
      alter table transfers add constraint between_accounts check (source_id != destination_id);
      alter table exchanges add constraint between_accounts check (source_id != destination_id);
    ]
  end
end
