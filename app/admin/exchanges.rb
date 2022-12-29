ActiveAdmin.register Exchange do
  extend PaginateByMonth
  extend ConfirmableResource
  extend TwoAccountsSidebar

  includes :source, :destination

  menu priority: 4

  decorate_with ExchangeDecorator

  config.sort_order = "date_desc"
  config.paginate = false

  permit_params :source_id, :destination_id, :value_in, :value_out, :fee,
    :date, :fee_kind, :kind, :transaction_hash

  filter :confirmed
  filter :kind, as: :select, collection: proc { ExchangeKind.list }
  filter :fee_kind, as: :select, collection: proc { ExchangeFeeKind.list }
  filter :source, collection: proc { Account.ordered }
  filter :destination, collection: proc { Account.ordered }
  filter :value_in
  filter :value_out
  filter :fee
  filter :date
  filter :transaction_hash

  index do
    selectable_column

    id_column

    column :confirmed
    column :kind
    column :source
    column :destination
    column :value_in
    column :value_out
    column :fee
    column :exchange_rate
    column :date

    actions
  end

  show do
    attributes_table do
      row :confirmed
      row :kind
      row :fee_kind do |exchange|
        exchange.fee_kind_humanize
      end
      row :source
      row :destination
      row :value_in
      row :value_out
      row :exchange_rate
      row :fee
      row :date
      row :transaction_hash
    end

    active_admin_comments
  end

  form do |f|
    f.object.kind ||= ExchangeKind.value_for("BUY")
    f.object.date ||= Date.current

    f.inputs t("active_admin.details", model: Exchange) do
      input :kind,
        input_html: { autofocus: true, disabled: resource.confirmed? },
        collection: ExchangeKind.list
      input :fee_kind,
        input_html: { disabled: resource.confirmed? },
        collection: ExchangeFeeKind.to_a
      input :source,
        input_html: { disabled: resource.confirmed? },
        collection: Account.ordered
      input :destination, collection: Account.ordered,
        input_html: { disabled: resource.confirmed? }
      input :value_in, input_html: { disabled: resource.confirmed? }
      input :value_out, input_html: { disabled: resource.confirmed? }
      input :fee, input_html: { disabled: resource.confirmed? }
      input :date, as: :string
      input :transaction_hash
    end

    f.actions
  end
end
