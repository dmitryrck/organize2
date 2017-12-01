class ExchangeDecorator < ApplicationDecorator
  delegate_all

  delegate :precision, :currency, to: :source, allow_nil: true, prefix: true
  delegate :precision, :currency, to: :destination, allow_nil: true, prefix: true

  def description
    [source, destination].join(" -> ")
  end

  def value
    [value_in, value_out].join(" -> ")
  end

  def source
    object.source
  end

  def value_in
    to_currency(object.value_in, currency: destination_currency, precision: destination_precision)
  end

  def value_out
    to_currency(object.value_out, currency: source_currency, precision: source_precision)
  end

  def fee
    to_currency(object.fee, currency: destination_currency, precision: destination_precision)
  end

  def exchange_rate
    to_currency(object.exchange_rate, currency: source_currency, precision: [destination_precision, source_precision].max)
  end
end
