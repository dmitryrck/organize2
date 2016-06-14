class OutgosController < MovementsController
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
    @outgos = find_outgos(@outgo)

    @outgo.paid_at = Date.current
  end

  def show
    @outgo = Outgo.find(params[:id])
    @outgos = find_outgos(@outgo)
  end

  def edit
    @outgo = Outgo.find(params[:id])
    @outgos = find_outgos(@outgo)
  end

  def create
    @outgo = Outgo.new(outgo_params)
    @outgo.save

    @outgos = find_outgos(@outgo)

    respond_with @outgo
  end

  def update
    @outgo = Outgo.find(params[:id])
    @outgo.update(outgo_params)
    @outgos = find_outgos(@outgo)
    respond_with @outgo
  end

  def confirm
    @outgo = Outgo.find(params[:id])
    if @outgo.paid?
      flash[:notice] = 'Outgo is already confirmed'
    else
      if @outgo.chargeable.is_a?(Account)
        account = @outgo.chargeable

        @outgo.transaction do
          @outgo.update_column(:paid, true)
          @outgo.outgos.update_all(paid: true)
          account.update_column(:balance, account.balance - @outgo.total)
        end

        flash[:notice] = 'Outgo was successfully confirmed'
      else
        flash[:notice] = 'Outgo has wrong chargeable kind'
      end
    end

    if params[:back] == 'show'
      redirect_to @outgo
    else
      redirect_to outgos_path(year: @outgo.year, month: @outgo.month)
    end
  end

  def unconfirm
    @outgo = Outgo.find(params[:id])
    if @outgo.chargeable.is_a?(Account)
      account = @outgo.chargeable

      @outgo.transaction do
        @outgo.update_column(:paid, false)
        @outgo.outgos.update_all(paid: false)
        account.update_column(:balance, account.balance + @outgo.total)
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
    @outgo = Outgo.find(params[:id])
    if @outgo.unpaid?
      year, month = @outgo.year, @outgo.month

      @outgo.destroy
      redirect_to outgos_path(year: year, month: month), notice: 'Outgo was successfully destroyed'
    else
      redirect_to @outgo, notice: "Outgo can't be destroyed"
    end
  end

  private

  def find_outgos(outgo)
    if outgo.card.present?
      (outgo.card.movements.unpaid + outgo.outgos).
        uniq.
        sort do |x, y|
          [x.paid_at, x.id] <=> [y.paid_at, y.id]
        end
    else
      []
    end
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
