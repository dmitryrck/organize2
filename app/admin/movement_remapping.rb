ActiveAdmin.register MovementRemapping do
  config.sort_order = "order_asc"

  permit_params :active, :kind, :field_to_watch, :text_to_match, :kind_of_match, :field_to_change, :kind_of_change,
    :text_to_change, :order

  filter :active
  filter :order
  filter :kind
  filter :field_to_watch, as: :select, collection: proc { MovementField.list }
  filter :kind_of_match, as: :select, collection: proc { KindOfChange.list }
  filter :text_to_match
  filter :kind_of_change, as: :select, collection: proc { KindOfChange.list }
  filter :field_to_change, as: :select, collection: proc { MovementField.list }
  filter :text_to_change

  scope :active
  scope :inactive

  action_item :new, only: :show do
    link_to t("active_admin.new_model", model: resource_class.model_name.human), { action: :new }
  end

  index do
    selectable_column

    id_column

    column :active
    column :order
    column :kind
    column :field_to_watch
    column :kind_of_match
    column :text_to_match
    column :kind_of_change
    column :field_to_change
    column :text_to_change

    actions
  end

  form do |f|
    f.object.active ||= true
    f.object.kind ||= MovementKind.value_for("OUTGO")
    f.object.field_to_watch ||= MovementField.value_for("DESCRIPTION")
    f.object.kind_of_match ||= KindOfMatch.value_for("CONTAINS")
    f.object.kind_of_change ||= KindOfChange.value_for("REPLACE")
    f.object.field_to_change ||= MovementField.value_for("CATEGORY")

    f.inputs t("active_admin.details", model: MovementRemapping) do
      input :active
      input :order
      input :kind, collection: MovementKind.list
      input :field_to_watch, collection: MovementField.list
      input :kind_of_match, collection: KindOfMatch.list
      input :text_to_match, input_html: { autofocus: true }
      input :kind_of_change, collection: KindOfChange.list
      input :field_to_change, collection: MovementField.list
      input :text_to_change
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :active
      row :order
      row :kind
      row :field_to_watch
      row :kind_of_match
      row :text_to_match
      row :kind_of_change
      row :field_to_change
      row :text_to_change
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end
end
