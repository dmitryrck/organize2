class OutgosController < MovementsController
  before_action :set_outgo, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @movements = Outgo.ordered.by_period(@period)
  end

  def new
    @outgo =
      if params[:outgo].present?
        Outgo.new(outgo_params)
      else
        Outgo.new do |outgo|
          outgo.chargeable_type = 'Account'
        end
      end

    @outgo.paid_at = Date.current
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
    if @outgo.chargeable.is_a?(Account)
      account = @outgo.chargeable

      @outgo.transaction do
        @outgo.update_column(:paid, true)
        account.update_column(:balance, account.balance - @outgo.value)
      end

      flash[:notice] = 'Successfully confirmed'
    else
      flash[:notice] = 'Wrong chargeable kind'
    end

    redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
  end

  def unconfirm
    if @outgo.chargeable.is_a?(Account)
      account = @outgo.chargeable

      @outgo.transaction do
        @outgo.update_column(:paid, false)
        account.update_column(:balance, account.balance + @outgo.value)
      end

      flash[:notice] = 'Successfully unconfirmed'
    else
      flash[:notice] = 'Wrong chargeable kind'
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
      .permit(
        :description, :chargeable_id, :chargeable_type, :value, :paid,
        :paid_at, :category, :parent_id, :card_id,
        outgo_ids: []
      )
  end
end
