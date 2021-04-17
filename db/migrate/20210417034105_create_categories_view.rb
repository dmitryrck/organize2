class CreateCategoriesView < ActiveRecord::Migration[4.2]
  def up
    execute %[
      create view categories as
        select
            movements.category as name
          , count(*) as movements_count
        from movements
        where movements.category is not null and movements.category != ''
        group by movements.category
        order by movements.category;
    ]
  end

  def down
    execute "drop view categories;"
  end
end
