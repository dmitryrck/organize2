ActiveAdmin.register Account do
  permit_params :name, :start_balance, :active, :currency, :precision

  config.sort_order = "active_desc"

  filter :active
  filter :name
  filter :currency
  filter :balance

  scope :active
  scope :inactive

  index do
    selectable_column

    id_column

    column :active
    column :name
    column :currency
    column :balance do |account|
      if account.currency.present?
        number_to_currency(account.balance, unit: account.currency, precision: account.precision)
      end
    end

    actions
  end

  show do
    attributes_table do
      row :active
      row :name
      row :start_balance do |account|
        if account.currency.present?
          number_to_currency(account.start_balance, unit: account.currency, precision: account.precision)
        end
      end
      row :balance do |account|
        if account.currency.present?
          number_to_currency(account.balance, unit: account.currency, precision: account.precision)
        end
      end
      row :currency
      row :precision
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    inputs t("active_admin.details", model: Account) do
      input :active
      input :name, input_html: { autofocus: true }
      if account.new_record?
        input :start_balance
      end
      input :currency
      input :precision
    end

    actions
  end
end
