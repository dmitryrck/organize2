class MovementsController < ApplicationController
  def index
    scope = object_class.ordered

    scope = if params.fetch(:q, nil).present?
              scope.search(params[:q])
            else
              @period = find_period
              scope.by_period(@period)
            end

    @movements = scope.decorate
    @summary = MovementsDecorator.new(@movements)
  end

  private

  def find_period
    Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
  end

  def object_class
    controller_name.singularize.camelize.constantize
  end
end
