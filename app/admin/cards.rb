ActiveAdmin.register Card do
  menu priority: 7

  decorate_with CardDecorator

  permit_params :name, :limit, :payment_day, :precision, :currency

  action_item :new_payment, only: :show do
    link_to 'Make a payment', new_admin_outgo_path(outgo: { card_id: card.id })
  end

  filter :active
  filter :name
  filter :limit
  filter :payment_day

  scope :active
  scope :inactive

  index do
    selectable_column

    id_column

    column :active
    column :name
    column :currency
    column :limit
    column :payment_day

    actions
  end

  show do
    attributes_table do
      row :active
      row :name
      row :limit
      row :payment_day
      row :currency
      row :precision
      row :created_at
      row :updated_at
    end

    panel Card.human_attribute_name(:movements) do
      table_for card.movements.unconfirmed.ordered do
        column :id
        column :description do |outgo|
          outgo.decorate.description
        end
        column :value do |outgo|
          outgo.decorate.value
        end
        column :date
        column :view do |outgo|
          link_to outgo.id, admin_outgo_path(outgo)
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs t("active_admin.details", model: Account) do
      input :active
      input :name, input_html: { autofocus: true }
      input :limit
      input :currency
      input :payment_day
      input :precision
    end

    f.actions
  end
end
