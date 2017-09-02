module ConfirmableResource
  def self.extended(base)
    base.instance_eval do
      action_item :confirmation, only: :show do
        action = if resource.confirmed?
                   :unconfirm
                 else
                   :confirm
                 end

        link_to t("actions.#{action}"), { action: action, id: resource, back: :show }
      end

      member_action :confirm, method: :get do
        toggle_confirm(resource, params[:action])
      end

      member_action :unconfirm, method: :get do
        toggle_confirm(resource, params[:action])
      end

      controller do
        def toggle_confirm(resource, action)
          AccountUpdater::Resolver.execute!(Draper.undecorate(resource), action: action)

          flash[:notice] = t("confirmable.#{params[:action]}", model: resource_class.model_name.human)

          if params[:back] == "show"
            redirect_to url_for({ action: :show, id: resource })
          else
            redirect_to url_for({ action: :index, year: resource.year, month: resource.month })
          end
        end
      end
    end
  end
end
