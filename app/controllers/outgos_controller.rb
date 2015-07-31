class OutgosController < ApplicationController
  before_action :set_outgo, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @outgos = Outgo.ordered
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
      account.update_column(:current_balance, account.current_balance - @outgo.value)
    end
    redirect_to edit_outgo_path(@outgo)
  end

  def unconfirm
    account = @outgo.account

    @outgo.transaction do
      @outgo.update_column(:paid, false)
      account.update_column(:current_balance, account.current_balance + @outgo.value)
    end
    redirect_to edit_outgo_path(@outgo)
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
