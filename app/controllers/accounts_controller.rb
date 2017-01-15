class AccountsController < ApplicationController
  respond_to :html

  def index
    @accounts = Account.ordered.decorate
  end

  def show
    @account = find_account
    respond_with(@account)
  end

  def new
    @account = Account.new
    respond_with(@account)
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(account_params) do |account|
      account.balance = account.start_balance
    end
    @account.save
    respond_with(@account)
  end

  def update
    @account = find_account
    @account.update(account_params)
    respond_with(@account)
  end

  private

  def find_account
    Account.find(params[:id]).decorate
  end

  def account_params
    params
      .require(:account)
      .permit(:active, :name, :currency, :start_balance, :balance, :precision)
  end
end
