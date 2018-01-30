ActiveAdmin.register Transfer do
  extend PaginateByMonth
  extend ConfirmableResource
  extend TwoAccountsSidebar

  menu priority: 3

  decorate_with TransferDecorator

  permit_params :source_id, :destination_id, :value, :date, :transaction_hash,
    :drive_id, :fee

  filter :source, collection: proc { Account.ordered }
  filter :destination, collection: proc { Account.ordered }
  filter :value
  filter :fee
  filter :confirmed
  filter :date
  filter :transaction_hash

  index do
    selectable_column

    id_column

    column :confirmed
    column :source
    column :destination
    column :value
    column :fee
    column :date

    actions
  end

  show do
    attributes_table do
      row :confirmed
      row :source
      row :destination
      row :value
      row :fee
      row :date
      row :drive_id
      row :transaction_hash
    end

    active_admin_comments
  end

  form do |f|
    f.object.date ||= Date.current

    f.inputs t("active_admin.details", model: Transfer) do
      input :source,
        input_html: { autofocus: true, disabled: resource.confirmed? },
        collection: Account.ordered
      input :destination, collection: Account.ordered,
        input_html: { disabled: resource.confirmed? }
      input :value, input_html: { disabled: resource.confirmed? }
      input :fee, input_html: { disabled: resource.confirmed? }
      input :date, as: :string
      input :drive_id
      input :transaction_hash
    end

    f.actions
  end
end
