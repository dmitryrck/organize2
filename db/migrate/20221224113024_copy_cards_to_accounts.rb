class CopyCardsToAccounts < ActiveRecord::Migration[7.0]
  def up
    execute %[
    insert into accounts
      (card_id, card, "limit", active, name, currency, precision, start_balance, balance, created_at, updated_at)
      select
        cards.id, 't', cards.limit, cards.active, cards.name, cards.currency, cards.precision, 0, 0, cards.created_at, cards.updated_at from cards;
    ]
  end

  def down
    execute %[delete from accounts where card_id is not null;]
  end
end
