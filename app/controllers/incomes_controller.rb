class IncomesController < MovementsController
  before_action :set_income, only: [:show, :edit, :update, :destroy, :confirm, :unconfirm]

  respond_to :html

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
    if @income.paid?
      flash[:notice] = 'Income is already confirmed'
    else
      flash[:notice] = 'Income was successfully confirmed'
      account = @income.chargeable

      @income.transaction do
        @income.update_column(:paid, true)
        account.update_column(:balance, account.balance + @income.value)
      end
    end

    if params[:back] == 'show'
      redirect_to @income
    else
      redirect_to incomes_path(year: @income.year, month: @income.month)
    end
  end

  def unconfirm
    account = @income.chargeable

    @income.transaction do
      @income.update_column(:paid, false)
      account.update_column(:balance, account.balance - @income.value)
    end

    flash[:notice] = 'Income was successfully unconfirmed'

    if params[:back] == 'show'
      redirect_to @income
    else
      redirect_to incomes_path(year: @income.year, month: @income.month)
    end
  end

  def destroy
    if @income.unpaid?
      year, month = @income.year, @income.month

      @income.destroy
      redirect_to incomes_path(year: year, month: month), notice: 'Income was successfully destroyed'
    else
      redirect_to @income, notice: "Income can't be destroyed"
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
