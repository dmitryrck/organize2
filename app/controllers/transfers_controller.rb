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
    source = @transfer.source
    destination = @transfer.destination

    @transfer.transaction do
      @transfer.update_column(:transfered, true)
      source.update_column(:balance, source.balance - @transfer.value)
      destination.update_column(:balance, destination.balance + @transfer.value)
    end

    flash[:notice] = 'Successfully transfered'

    redirect_to transfers_path(year: @transfer.year, month: @transfer.month)
  end

  def unconfirm
    source = @transfer.source
    destination = @transfer.destination

    @transfer.transaction do
      @transfer.update_column(:transfered, false)
      source.update_column(:balance, source.balance + @transfer.value)
      destination.update_column(:balance, destination.balance - @transfer.value)
    end

    flash[:notice] = 'Successfully unconfirmed'

    redirect_to transfers_path(year: @transfer.year, month: @transfer.month)
  end

  private

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  def transfer_params
    params
      .require(:transfer)
      .permit(:source_id, :destination_id, :value, :transfered_at)
  end
end
