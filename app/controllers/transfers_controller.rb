class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @transfers = Transfer.ordered.by_period(@period)
  end

  def show
    respond_with(@transfer)
  end

  def new
    @transfer = Transfer.new do |transfer|
      transfer.transfered_at = Date.current
    end

    respond_with(@transfer)
  end

  def edit
  end

  def create
    @transfer = Transfer.new(transfer_params)
    @transfer.save
    respond_with(@transfer)
  end

  def update
    @transfer.update(transfer_params)
    respond_with(@transfer)
  end

  def confirm
    AccountUpdater::TransferConfirm.update!(@transfer)

    flash[:notice] = 'Transfer was successfully transfered'

    if params[:back] == 'show'
      redirect_to @transfer
    else
      redirect_to transfers_path(year: @transfer.year, month: @transfer.month)
    end
  end

  def unconfirm
    AccountUpdater::TransferUnconfirm.update!(@transfer)

    flash[:notice] = 'Transfer was successfully unconfirmed'

    if params[:back] == 'show'
      redirect_to @transfer
    else
      redirect_to transfers_path(year: @transfer.year, month: @transfer.month)
    end
  end

  private

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def transfer_params
    params
      .require(:transfer)
      .permit(:source_id, :destination_id, :value, :transfered_at, :fee)
  end
end
