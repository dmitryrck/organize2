class TradesController < ApplicationController
  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @trades = Trade.ordered.by_period(@period).decorate
  end

  def show
    @trade = find_trade
    respond_with(@trade)
  end

  def new
    @trade = Trade.new do |trade|
      trade.trade_at = Date.current
    end

    respond_with(@trade)
  end

  def edit
    @trade = Trade.find(params[:id])
  end

  def create
    @trade = Trade.new(trade_params)
    @trade.save
    respond_with(@trade)
  end

  def update
    @trade = find_trade
    @trade.update(trade_params)
    respond_with(@trade)
  end

  def destroy
    @trade = Trade.find(params[:id])
    @trade.destroy
    respond_with(@trade)
  end

  def confirm
    @trade = Trade.find(params[:id])

    AccountUpdater::TradeConfirm.update!(@trade)

    flash[:notice] = 'Trade was successfully confirmed'

    if params[:back] == 'show'
      redirect_to @trade
    else
      redirect_to trades_path(year: @trade.year, month: @trade.month)
    end
  end

  def unconfirm
    @trade = Trade.find(params[:id])

    AccountUpdater::TradeUnconfirm.update!(@trade)

    flash[:notice] = 'Trade was successfully unconfirmed'

    if params[:back] == 'show'
      redirect_to @trade
    else
      redirect_to trades_path(year: @trade.year, month: @trade.month)
    end
  end

  private

  def find_trade
    Trade.find(params[:id]).decorate
  end

  def trade_params
    params.
      require(:trade).
      permit(:source_id, :destination_id, :value_in, :value_out, :fee, :trade_at)
  end
end
