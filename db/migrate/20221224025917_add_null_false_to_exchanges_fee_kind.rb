class AddNullFalseToExchangesFeeKind < ActiveRecord::Migration[7.0]
  def up
    execute %[
      update exchanges set fee_kind = 'source' where fee_kind is null;
      alter table public.exchanges alter column fee_kind set not null;
    ]
  end

  def down
    execute %[
      alter table public.exchanges alter column fee_kind drop not null;
    ]
  end
end
