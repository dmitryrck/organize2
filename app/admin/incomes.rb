ActiveAdmin.register Income do
  extend PaginateByMonth
  extend ConfirmableResource
  extend OneAccountSidebar

  includes :chargeable

  menu priority: 2

  decorate_with IncomeDecorator

  config.sort_order = "date_desc"
  config.paginate = false

  filter :description
  filter :paid_to
  filter :confirmed
  filter :date
  filter :chargeable_id, as: :select, collection: proc { Account.ordered }
  filter :category
  filter :value
  filter :transaction_hash

  permit_params :description, :value, :date, :category, :chargeable_type,
    :chargeable_id, :transaction_hash, :paid_to

  action_item :duplicate, only: :show do
    link_to "Duplicate", new_admin_income_path(income: income.duplicable_attributes)
  end

  controller do
    def create
      build_resource

      @income.admin_user = current_admin_user

      create!
    end
  end

  index do
    selectable_column

    id_column

    column :confirmed
    column :description
    column :value
    column :chargeable
    column :date

    actions
  end

  show do
    attributes_table do
      row :confirmed
      row :description do |income|
        income.object.description
      end
      row :paid_to
      row :category
      row :date
      row :chargeable
      row :value
      row :transaction_hash
      row :admin_user
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    inputs t("active_admin.details", model: Income) do
      semantic_errors :chargeable
      input :description, input_html: { autofocus: true }
      input :paid_to
      input :date, as: :string, input_html: { value: (f.object.date || Date.current) }
      input :category
      input :chargeable_type, as: :hidden, input_html: { value: "Account", disabled: income.confirmed? }
      input :chargeable_id, collection: Account.active.ordered, as: :select, input_html: { disabled: income.confirmed? }
      input :value, input_html: { disabled: income.confirmed? }
      input :transaction_hash
    end

    actions
  end
end
