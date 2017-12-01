ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        [Outgo, Income, Transfer, Exchange].each do |model|
          panel "Pending #{model.model_name.human}" do
            table_for model.unconfirmed.decorate do
              column :description
              column :value
              column :view do |object|
                link_to "view", url_for({ id: object.id, controller: "admin/#{model.name.underscore.pluralize}", action: :show })
              end
            end
          end
        end
      end
    end
  end
end
