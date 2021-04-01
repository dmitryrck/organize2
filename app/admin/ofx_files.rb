ActiveAdmin.register OfxFile do
  filter :description
  filter :created_at
  filter :updated_at

  permit_params :description

  action_item :refresh, only: :show do
    link_to "Refresh", admin_ofx_file_path(ofx_file)
  end

  controller do
    def create
      build_resource

      if params[:ofx_file].present? && params[:ofx_file][:file].present?
        @ofx_file.content = params[:ofx_file][:file].read
      end

      create!
    end
  end

  index do
    selectable_column

    id_column

    column :description
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :description
      row :bank_ids
      row :outgos do
        table_for ofx_file.outgos do
          column "#", { class: "col-id" } do |outgo|
            if outgo.persisted?
              "##{outgo.id}"
            else
              "##"
            end
          end
          column :confirmed
          column :description
          column :value
          column "Account/Card", :chargeable
          column :date
          column do |outgo|
            if outgo.persisted?
              [
                link_to("View", admin_outgo_path(outgo), class: "edit_link member_link"),
                link_to("Edit", edit_admin_outgo_path(outgo), class: "edit_link member_link"),
              ].join.html_safe
            else
              link_to "New", new_admin_outgo_path(outgo: outgo.duplicable_attributes.merge(date: outgo.date))
            end
          end
        end
      end
    end
  end

  sidebar :note, only: :show do
    "This is only to confirm your Organize2 transactions are all here"
  end

  sidebar :note2, only: :show do
    "The Outgos are searched by Account & value & date. If there are two of the same Account & value & date there will be nothing to show here."
  end

  form do |f|
    f.inputs t("active_admin.details", model: OfxFile) do
      input :description, input_html: { autofocus: true }
      input :file, as: :file if ofx_file.new_record?
    end

    f.actions
  end
end
