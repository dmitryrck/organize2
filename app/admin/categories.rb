ActiveAdmin.register Category do
  actions :index, :show, :edit

  config.sort_order = "name_asc"

  permit_params :name

  filter :name

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

  controller do
    def update
      new_category = permitted_params[:category].fetch(:name)

      Movement.where(category: params[:id]).update_all(category: new_category)
      redirect_to admin_category_path(new_category)
    end
  end

  form do |f|
    f.inputs t("active_admin.details", model: Category) do
      input :name
    end

    f.actions
  end

  sidebar :note, only: :show do
    "<strong>Summary</strong> is from 1 year ago (#{l(category.one_year_ago, format: :long)})".html_safe
  end
end
