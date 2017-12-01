class AccountDecorator < ApplicationDecorator
  delegate_all

  def balance
    to_currency(object.balance, currency: currency, precision: precision)
  end

  def start_balance
    to_currency(object.start_balance, currency: currency, precision: precision)
  end
end
