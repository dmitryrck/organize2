class IncomeDecorator < Draper::Decorator
  delegate_all

  delegate :precision, to: :chargeable, allow_nil: true

  def total
    h.number_to_currency(object.value, precision: precision)
  end
end
