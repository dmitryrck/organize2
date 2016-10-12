class MovementsController < ApplicationController
  def index
    if params.fetch(:q, nil).present?
      @movements = object_class.ordered.search(params[:q])
    else
      @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
      @movements = object_class.ordered.by_period(@period)
    end
  end

  def show
    @movement = Movement.find(params[:id])
  end

  def update
    @movement = Movement.find(params[:id])
    if @movement.update(movement_params)
      redirect_to @movement
    else
      render :show
    end
  end

  private

  def movement_params
    params
      .require(:movement)
      .permit(
        :card_id,
        :category,
        :chargeable_id,
        :chargeable_type,
        :description,
        :fee,
        :fee_kind,
        :paid,
        :paid_at,
        :parent_id,
        :value,
        outgo_ids: [],
      )
  end

  def object_class
    controller_name.singularize.camelize.constantize
  end
end
