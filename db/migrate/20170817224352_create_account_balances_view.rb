class CreateAccountBalancesView < ActiveRecord::Migration[5.1]
  def up
    execute %[
      create view account_balances as
        select currency, sum(balance) as value, cast(avg(precision) as integer) as precision
        from accounts
        group by currency;
    ]
  end

  def down
    execute "drop view account_balances"
  end
end
