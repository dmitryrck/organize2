class MovementsController < ApplicationController
  def index
    if params.fetch(:q, nil).present?
      @movements = object_class.ordered.search(params[:q])
    else
      @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
      @movements = object_class.ordered.by_period(@period)
    end
  end

  private

  def object_class
    controller_name.singularize.camelize.constantize
  end
end
