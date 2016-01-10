class MovementsController < ApplicationController
  def index
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
end
