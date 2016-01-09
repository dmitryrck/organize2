class OutgosController < MovementsController
  before_action :set_outgo, only: [:show, :edit, :update, :destroy, :confirm, :unconfirm]

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

      flash[:notice] = 'Outgo was successfully confirmed'
    else
      flash[:notice] = 'Outgo has wrong chargeable kind'
    end

    if params[:back] == 'show'
      redirect_to @outgo
    else
      redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
    end
  end

  def unconfirm
    if @outgo.chargeable.is_a?(Account)
      account = @outgo.chargeable

      @outgo.transaction do
        @outgo.update_column(:paid, false)
        account.update_column(:balance, account.balance + @outgo.value)
      end

      flash[:notice] = 'Outgo was successfully unconfirmed'
    else
      flash[:notice] = 'Outgo has wrong chargeable kind'
    end

    if params[:back] == 'show'
      redirect_to @outgo
    else
      redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
    end
  end

  def destroy
    if @outgo.unpaid?
      year, month = @outgo.year, @outgo.month

      @outgo.destroy
      redirect_to outgos_path(year: year, month: month), notice: 'Outgo was successfully destroyed'
    else
      redirect_to @outgo, notice: "Outgo can't be destroyed"
    end
  end

  private

  def set_outgo
    @outgo = Outgo.find(params[:id])
  end

  def outgo_params
    params
      .require(:outgo)
      .permit(
        :card_id,
        :category,
        :chargeable_id,
        :chargeable_type,
        :description,
        :fee,
        :fee_kind,
        :paid_at,
        :parent_id,
        :value,
        outgo_ids: [],
      )
  end
end
