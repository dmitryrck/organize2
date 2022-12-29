class FixTypeOfNegativeOutgosForAccountsCard < ActiveRecord::Migration[7.0]
  def up
    execute %[
do $$
declare
  account record;
begin
  for account in
    select
      accounts.id as id, accounts.card_id as card_id
    from
      accounts
    where
      accounts.card = 't' and accounts.card_id is not null
  loop
    update
      movements
    set
        kind = 'Income'
      , value = (value * (-1))
    where
      kind = 'Outgo'
      and chargeable_id = account.id
      and value < 0
    ;
  end loop;
end;
$$;
  ]
  end

  def down
    puts :NOOP
  end
end
