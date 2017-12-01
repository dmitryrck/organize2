class TransferDecorator < ApplicationDecorator
  delegate_all

  delegate :precision, :currency, to: :source, allow_nil: true

  def description
    [source, destination].join(" -> ")
  end

  def source
    object.source
  end

  def value
    to_currency(object.value, currency: currency, precision: precision)
  end

  def fee
    to_currency(object.fee, currency: currency, precision: precision)
  end
end
