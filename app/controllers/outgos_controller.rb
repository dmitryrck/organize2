class OutgosController < ApplicationController
  before_action :set_outgo, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @outgos = Outgo.ordered.by_period(@period)
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

  def confirm
    account = @outgo.account

    @outgo.transaction do
      @outgo.update_column(:paid, true)
      account.update_column(:balance, account.balance - @outgo.value)
    end
    redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
  end

  def unconfirm
    account = @outgo.account

    @outgo.transaction do
      @outgo.update_column(:paid, false)
      account.update_column(:balance, account.balance + @outgo.value)
    end
    redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
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
