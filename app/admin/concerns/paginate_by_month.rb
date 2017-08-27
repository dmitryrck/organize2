module PaginateByMonth
  def self.extended(base)
    base.instance_eval do
      action_item :previous, only: :index do
        month_link_to(params, method: :prev, locale: "Previous month")
      end

      action_item :next, only: :index do
        month_link_to(params, locale: "Next month")
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
