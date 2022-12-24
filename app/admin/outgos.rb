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
  filter :chargeable_id, as: :select, collection: proc { Account.ordered }
  filter :category
  filter :value
  filter :fee
  filter :fee_kind, as: :select, collection: proc { FeeKind.to_a }
  filter :expected_movement
  filter :transaction_hash

  permit_params :description, :value, :date, :category, :fee,
    :fee_kind, :chargeable_type, :chargeable_id, :transaction_hash,
    :expected_movement, :repeat_expense, :paid_to, :parent_id, outgo_ids: []

  action_item :duplicate, only: :show do
    link_to "Duplicate", new_admin_outgo_path(outgo: outgo.duplicable_attributes)
  end

  controller do
    def create
      ActiveRecord::Base.transaction do
        build_resource

        @outgo.chargeable_type = "Account"
        @outgo.admin_user = current_admin_user

        Remapper.call(@outgo)

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
      row :parent
      row :expected_movement
      row :transaction_hash
      row :admin_user
      row :created_at
      row :updated_at
    end

    panel Outgo.human_attribute_name(:outgos) do
      render partial: "child_outgos", locals: { outgos: OutgoDecorator.decorate_collection(outgo.outgos.order("date desc")) }
    end

    active_admin_comments
  end

  form do |f|
    f.inputs t("active_admin.details", model: Outgo) do
      input :description, input_html: { autofocus: true }
      input :paid_to
      input :date, as: :string, input_html: { value: (f.object.date || Date.current) }
      input :category
      input :chargeable_id, as: :select, collection: Account.active.ordered, input_html: { disabled: outgo.confirmed? }
      input :value, input_html: { disabled: outgo.confirmed? }
      input :fee, input_html: { disabled: outgo.confirmed? }
      input :parent_id
      input :fee_kind, collection: FeeKind.to_a
      input :expected_movement
      if outgo.new_record?
        input :repeat_expense, as: :text
      end
      input :transaction_hash
    end

    f.actions
  end

  batch_action :set_as_expected do |ids|
    Outgo.where(id: ids).update_all(expected_movement: true)
    redirect_to collection_path, notice: "Outgos updated successfully"
  end

  batch_action :set_as_unexpected do |ids|
    Outgo.where(id: ids).update_all(expected_movement: false)
    redirect_to collection_path, notice: "Outgos updated successfully"
  end
end
