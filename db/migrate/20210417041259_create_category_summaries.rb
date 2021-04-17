class CreateCategorySummaries < ActiveRecord::Migration[4.2]
  def up
    execute %[
      create view category_summaries as
        select
            to_char(date, 'YYYY-MM') as month
          , accounts.currency as currency
          , category as name
          , sum(value)
          , expected_movement
        from movements
        inner join accounts on chargeable_id = accounts.id and chargeable_type = 'Account'
        where kind = 'Outgo'
        group by month, movements.category, currency, expected_movement
        order by month, name;
    ]
  end

  def down
    execute "drop view category_summaries;"
  end
end
