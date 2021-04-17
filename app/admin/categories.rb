ActiveAdmin.register Category do
  actions :index, :show

  config.sort_order = "name_asc"

  index do
    selectable_column

    id_column

    column :movements_count

    actions
  end

  show do
    attributes_table do
      row :name
      row :movements_count
      row :summary do
        table_for category.summary do
          column("Month & currency") { |summary| summary[:month_currency] }
          column(:expected_movement) { |summary| number_to_currency(summary[:expected_movement]) }
          column(:unexpected_movement) { |summary| number_to_currency(summary[:unexpected_movement]) }
        end
      end
    end
  end

  sidebar :note, only: :show do
    "<strong>Summary</strong> is from 1 year ago (#{l(category.one_year_ago, format: :long)})".html_safe
  end
end
