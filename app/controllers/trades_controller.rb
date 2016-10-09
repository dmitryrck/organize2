class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update, :destroy, :confirm, :unconfirm]

  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @trades = Trade.ordered.by_period(@period)
  end

  def show
    respond_with(@trade)
  end

  def new
    @trade = Trade.new do |trade|
      trade.trade_at = Date.current
    end

    respond_with(@trade)
  end

  def edit
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.save
    respond_with(@trade)
  end

  def update
    @trade.update(trade_params)
    respond_with(@trade)
  end

  def destroy
    @trade.destroy
    respond_with(@trade)
  end

  def confirm
    AccountUpdater::TradeConfirm.update!(@trade)

    flash[:notice] = 'Trade was successfully confirmed'

    if params[:back] == 'show'
      redirect_to @trade
    else
      redirect_to trades_path(year: @trade.year, month: @trade.month)
    end
  end

  def unconfirm
    AccountUpdater::TradeUnconfirm.update!(@trade)

    flash[:notice] = 'Trade was successfully unconfirmed'

    if params[:back] == 'show'
      redirect_to @trade
    else
      redirect_to trades_path(year: @trade.year, month: @trade.month)
    end
  end

  private

  def set_trade
    @trade = Trade.find(params[:id])
  end

  def trade_params
    params.require(:trade).permit(:source_id, :destination_id, :value_in, :value_out, :fee, :trade_at)
  end
end
