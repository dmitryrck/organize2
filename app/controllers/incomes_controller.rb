class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @incomes = Income.all
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

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params
      .require(:income)
      .permit(:description, :value, :paid, :expires_at, :paid_at, :category)
  end
end
