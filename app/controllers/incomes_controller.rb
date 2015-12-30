class IncomesController < MovementsController
  before_action :set_income, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @period = Period.new(params[:year] || Date.current.year, params[:month] || Date.current.month)
    @movements = Income.ordered.by_period(@period)
  end

  def new
    @income = Income.new(income_params) do |income|
      income.paid_at = Date.current
    end
  end

  def create
    @income = Income.new(income_params)
    @income.save

    respond_with @income
  end

  def update
    @income.update(income_params)
    respond_with @income
  end

  def confirm
    if @income.chargeable.is_a?(Account)
      account = @income.chargeable

      @income.transaction do
        @income.update_column(:paid, true)
        account.update_column(:balance, account.balance + @income.value)
      end

      flash[:notice] = 'Successfully confirmed'
    else
      flash[:notice] = 'Wrong chargeable kind'
    end

    if params[:back] == 'show'
      redirect_to @income
    else
      redirect_to incomes_path(year: @income.year, month: @income.month)
    end
  end

  def unconfirm
    if @income.chargeable.is_a?(Account)
      account = @income.chargeable

      @income.transaction do
        @income.update_column(:paid, false)
        account.update_column(:balance, account.balance - @income.value)
      end
      flash[:notice] = 'Successfully unconfirmed'
    else
      flash[:notice] = 'Wrong chargeable kind'
    end

    if params[:back] == 'show'
      redirect_to @income
    else
      redirect_to incomes_path(year: @income.year, month: @income.month)
    end
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params
      .fetch(:income, {})
      .permit(
        :description, :chargeable_id, :chargeable_type, :value, :paid_at,
        :category
      )
  end
end
