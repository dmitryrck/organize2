class MigrateOutgosFromCardToAccounts < ActiveRecord::Migration[7.0]
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
        chargeable_type = 'Account'
      , chargeable_id = account.id
    where
      chargeable_type = 'Card'
      and chargeable_id = account.card_id
    ;
  end loop;
end;
$$;
  ]
  end

  def down
    execute %[
do
$$
declare
  account record;
begin
  for account in
    select
      accounts.id as id, accounts.card_id as card_id
    from
      accounts
    where
      accounts.card = 't'
      and accounts.card_id is not null
  loop
    update
      movements
    set
        chargeable_type = 'Card'
      , chargeable_id = account.card_id
    where
      chargeable_type = 'Account'
      and chargeable_id = account.id
    ;
  end loop;
end;
$$;
  ]
  end
end
