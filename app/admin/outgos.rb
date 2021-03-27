ActiveAdmin.register Outgo do
  extend PaginateByMonth
  extend ConfirmableResource
  extend OneAccountSidebar

  includes :chargeable

  menu priority: 1

  decorate_with OutgoDecorator

  config.sort_order = "date_desc"
  config.paginate = false

  filter :confirmed
  filter :description
  filter :paid_to
  filter :date
  filter :category
  filter :value
  filter :fee
  filter :fee_kind, as: :select, collection: proc { FeeKind.to_a }
  filter :expected_movement
  filter :transaction_hash

  permit_params :description, :value, :date, :category, :card_id, :fee,
    :fee_kind, :chargeable_type, :chargeable_id, :drive_id, :transaction_hash,
    :expected_movement, :repeat_expense, :paid_to, :parent_id, outgo_ids: []

  action_item :duplicate, only: :show do
    link_to "Duplicate", new_admin_outgo_path(outgo: outgo.duplicable_attributes)
  end

  controller do
    def create
      ActiveRecord::Base.transaction do
        build_resource

        if @outgo.valid?
          @outgo.repeat_expense.split("\n").each do |line|
            other_outgo = Outgo.new(@outgo.attributes.except("id", "created_at", "updated_at", "transaction_hash"))
            other_outgo.date = Date.strptime(line.strip, "%Y-%m-%d")
            other_outgo.save!
          end
        end

        create!
      end
    end
  end

  sidebar :expected_expenses_sum, only: :index do
    outgos
      .select { |outgo| outgo.expected_movement? }
      .group_by { |outgo| outgo.currency }
      .map { |currency, outgos| [currency, outgos.sum { |outgo| Draper.undecorate(outgo).total }] }
      .each do |currency, sum|
        para "#{currency} #{sum}"
      end
  end

  sidebar :unexpected_expenses_sum, only: :index do
    outgos
      .select { |outgo| outgo.unexpected_movement? }
      .group_by { |outgo| outgo.currency }
      .map { |currency, outgos| [currency, outgos.sum { |outgo| Draper.undecorate(outgo).total }] }
      .each do |currency, sum|
        para "#{currency} #{sum}"
      end
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
      row :paid_to do
        outgo.object.paid_to
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
      row :parent
      row :expected_movement
      row :drive_id
      row :transaction_hash
      row :created_at
      row :updated_at
    end

    panel Outgo.human_attribute_name(:outgos) do
      table_for OutgoDecorator.decorate_collection(outgo.outgos.order("date desc")) do
        column :id
        column :confirmed
        column :description
        column :value
        column :date
        column do
          link_to "View", admin_outgo_path(outgo)
        end
        column do
          link_to "Edit", edit_admin_outgo_path(outgo)
        end
      end
    end

    active_admin_comments
  end

  form partial: "form"

  batch_action :set_as_expected do |ids|
    Outgo.where(id: ids).update_all(expected_movement: true)
    redirect_to collection_path, notice: "Outgos updated successfully"
  end

  batch_action :set_as_unexpected do |ids|
    Outgo.where(id: ids).update_all(expected_movement: false)
    redirect_to collection_path, notice: "Outgos updated successfully"
  end
end
