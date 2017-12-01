class ApplicationDecorator < Draper::Decorator
  private

  def to_currency(value = nil, currency: nil, precision: 2)
    value ||= 0.0
    h.number_to_currency(value, unit: (currency.presence || "$"), precision: precision.to_i)
  end
end
