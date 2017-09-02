module PaginateByMonth
  def self.extended(base)
    base.instance_eval do
      config.paginate = false

      action_item :previous, only: :index do
        month_link_to(params, method: :prev, locale: "Previous month")
      end

      action_item :next, only: :index do
        month_link_to(params, locale: "Next month")
      end

      action_item :new, only: :show do
        link_to t("active_admin.new_model", model: resource_class.model_name.human), { action: :new }
      end

      controller do
        def scoped_collection
          if params[:action] == "index" && params[:commit] != "Filter"
            period = Period.from_params(params)
            end_of_association_chain.by_period(period)
          else
            end_of_association_chain
          end
        end
      end
    end
  end
end

class ActiveAdmin::Views::ActionItems
  def month_link_to(params, method: :next, locale: "Next")
    period = Period.from_params(params)
    target = period.send(method)
    link_to locale, { month: target.month, year: target.year }
  end
end
