class TransferDecorator < Draper::Decorator
  delegate_all

  delegate :precision, to: :source, allow_nil: true

  def source
    object.source
  end

  def value
    h.number_to_currency(object.value, precision: precision)
  end

  def fee
    h.number_to_currency(object.fee, precision: precision)
  end
end
