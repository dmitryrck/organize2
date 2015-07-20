class OutgosController < ApplicationController
  before_action :set_outgo, only: [:show, :edit, :update]

  respond_to :html

  def index
    @outgos = Outgo.all
  end

  def new
    @outgo = Outgo.new do |outgo|
      outgo.paid_at = Date.current
    end
  end

  def create
    @outgo = Outgo.new(outgo_params)
    @outgo.save

    respond_with @outgo
  end

  def update
    @outgo.update(outgo_params)
    respond_with @outgo
  end

  private

  def set_outgo
    @outgo = Outgo.find(params[:id])
  end

  def outgo_params
    params
      .require(:outgo)
      .permit(:description, :account_id, :value, :paid, :paid_at,
              :category)
  end
end
