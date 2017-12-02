ActiveAdmin.register ExchangeRate do
  permit_params :market, :source, :destination, :last, :lowest_ask, :highest_bid

  filter :market
  filter :source
  filter :destination

  index do
    selectable_column

    id_column

    column :market
    column :source
    column :destination
    column :last
    column :lowest_ask
    column :highest_bid
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :market
      row :source
      row :destination
      row :last
      row :lowest_ask
      row :highest_bid
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs t("active_admin.details", model: ExchangeRate) do
      input :market, input_html: { autofocus: true }
      input :source
      input :destination
      input :last
      input :lowest_ask
      input :highest_bid
    end

    f.actions
  end
end
