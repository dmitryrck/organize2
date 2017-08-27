ActiveAdmin.register Transfer do
  extend PaginateByMonth

  menu priority: 3

  decorate_with TransferDecorator

  config.paginate = false

  permit_params :source_id, :destination_id, :value, :date, :transaction_hash,
    :fee

  action_item :new, only: :show do
    link_to t("active_admin.new_model", model: Transfer.model_name.human), new_admin_transfer_path
  end

  controller do
    def scoped_collection
      if params[:commit] != "Filter"
        period = Period.from_params(params)
        end_of_association_chain.by_period(period)
      else
        end_of_association_chain
      end
    end
  end

  action_item :confirmation, only: :show do
    if resource.confirmed?
      link_to t("actions.unconfirm"), unconfirm_admin_transfer_path(resource, back: :show)
    else
      link_to t("actions.confirm"), confirm_admin_transfer_path(resource, back: :show)
    end
  end

  member_action :confirm, method: :get do
    AccountUpdater::TransferConfirm.update!(Draper.undecorate(resource))

    flash[:notice] = "Transfer was completed successfully"

    if params[:back] == "show"
      redirect_to admin_transfer_path(resource)
    else
      redirect_to admin_transfers_path(year: resource.year, month: resource.month)
    end
  end

  member_action :unconfirm, method: :get do
    AccountUpdater::TransferUnconfirm.update!(Draper.undecorate(resource))

    flash[:notice] = "Transfer was successfully unconfirmed"

    if params[:back] == "show"
      redirect_to admin_transfer_path(resource)
    else
      redirect_to admin_transfers_path(year: @transfer.year, month: @transfer.month)
    end
  end

  filter :source, collection: proc { Account.ordered }
  filter :destination, collection: proc { Account.ordered }
  filter :value
  filter :fee
  filter :confirmed
  filter :date

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
      row :transaction_hash
    end

    active_admin_comments
  end

  form do |f|
    f.inputs t("active_admin.details", model: Transfer) do
      input :source,
        input_html: { autofocus: true, disabled: resource.confirmed? },
        collection: Account.ordered
      input :destination, collection: Account.ordered,
        input_html: { disabled: resource.confirmed? }
      input :value, input_html: { disabled: resource.confirmed? }
      input :fee, input_html: { disabled: resource.confirmed? }
      input :date, as: :string,
        input_html: { value: (transfer.date.presence || Date.current) }
      input :transaction_hash
    end

    f.actions
  end
end
