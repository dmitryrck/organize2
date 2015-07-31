class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :confirm, :unconfirm]

  respond_to :html

  def index
    @incomes = Income.ordered
  end

  def new
    @income = Income.new do |income|
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
    account = @income.account

    @income.transaction do
      @income.update_column(:paid, true)
      account.update_column(:balance, account.balance + @income.value)
    end
    redirect_to edit_income_path(@income)
  end

  def unconfirm
    account = @income.account

    @income.transaction do
      @income.update_column(:paid, false)
      account.update_column(:balance, account.balance - @income.value)
    end
    redirect_to edit_income_path(@income)
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params
      .require(:income)
      .permit(:description, :account_id, :value, :paid, :paid_at,
              :category)
  end
end
