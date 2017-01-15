class AccountDecorator < Draper::Decorator
  delegate_all

  def balance
    h.number_to_currency(object.balance, precision: precision)
  end

  def start_balance
    h.number_to_currency(object.start_balance, precision: precision)
  end
end
