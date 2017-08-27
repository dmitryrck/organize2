class AccountDecorator < Draper::Decorator
  delegate_all

  def balance
    currency(object.balance)
  end

  def start_balance
    currency(object.start_balance)
  end

  private

  def currency(value)
    h.number_to_currency(value, unit: (object.currency.presence || "$"), precision: object.precision.to_i)
  end
end
