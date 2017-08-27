class TransferDecorator < Draper::Decorator
  delegate_all

  delegate :precision, :currency, to: :source, allow_nil: true

  def source
    object.source
  end

  def value
    to_currency(object.value)
  end

  def fee
    to_currency(object.fee)
  end

  private

  def to_currency(value)
    h.number_to_currency((value.presence || 0), unit: (currency.presence || "$"), precision: precision.to_i)
  end
end
