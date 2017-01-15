class TradeDecorator < Draper::Decorator
  delegate_all

  delegate :precision, to: :source, allow_nil: true, prefix: true
  delegate :precision, to: :destination, allow_nil: true, prefix: true

  def source
    object.source
  end

  def value_in
    h.number_to_currency(object.value_in, precision: destination_precision)
  end

  def value_out
    h.number_to_currency(object.value_out, precision: source_precision)
  end

  def fee
    h.number_to_currency(object.fee, precision: destination_precision)
  end
end
