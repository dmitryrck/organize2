class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update]

  respond_to :html

  def index
    @accounts = Account.ordered
  end

  def show
    respond_with(@account)
  end

  def new
    @account = Account.new
    respond_with(@account)
  end

  def edit
  end

  def create
    @account = Account.new(account_params) do |account|
      account.balance = account.start_balance
    end
    @account.save
    respond_with(@account)
  end

  def update
    @account.update(account_params)
    respond_with(@account)
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params
      .require(:account)
      .permit(:name, :start_balance, :balance)
  end
end
