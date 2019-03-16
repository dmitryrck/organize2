ActiveAdmin.register Outgo do
  extend PaginateByMonth
  extend ConfirmableResource
  extend OneAccountSidebar

  menu priority: 1

  decorate_with OutgoDecorator

  config.sort_order = "date_asc"
  config.paginate = false

  filter :confirmed
  filter :description
  filter :date
  filter :category
  filter :value
  filter :fee
  filter :fee_kind, as: :select, collection: proc { FeeKind.to_a }
  filter :transaction_hash

  permit_params :description, :value, :date, :category, :card_id, :fee,
    :fee_kind, :chargeable_type, :chargeable_id, :drive_id, :transaction_hash,
    outgo_ids: []

  action_item :duplicate, only: :show do
    link_to "Duplicate", new_admin_outgo_path(outgo: outgo.duplicable_attributes)
  end

  sidebar :sum, only: :index do
    outgos
      .group_by { |outgo| outgo.currency }
      .map { |currency, outgos| [currency, outgos.sum { |outgo| Draper.undecorate(outgo).total }] }
      .each do |currency, sum|
        para "#{currency} #{sum}"
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
      row :description do |outgo|
        outgo.object.description
      end
      row :category
      row :date
      row :chargeable
      row :value
      row :fee
      row :fee_kind do |outgo|
        outgo.fee_kind_humanize
      end
      row :card
      row :drive_id
      row :transaction_hash
      row :created_at
      row :updated_at
    end

    panel Outgo.human_attribute_name(:outgos) do
      table_for outgo.outgos do
        column :id
        column :confirmed
        column :description
        column :value
        column :date
      end
    end

    active_admin_comments
  end

  form partial: "form"
end
