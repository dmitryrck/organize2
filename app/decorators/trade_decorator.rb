class TradeDecorator < Draper::Decorator
  delegate_all

  delegate :precision, :currency, to: :source, allow_nil: true, prefix: true
  delegate :precision, :currency, to: :destination, allow_nil: true, prefix: true

  def source
    object.source
  end

  def value_in
    "#{destination_currency} #{h.number_with_precision(object.value_in, precision: destination_precision)}"
  end

  def value_out
    "#{source_currency} #{h.number_with_precision(object.value_out, precision: source_precision)}"
  end

  def fee
    "#{destination_currency} #{h.number_with_precision(object.fee, precision: destination_precision)}"
  end

  def icon
    case trade.kind
    when "Buy"
      h.content_tag :i, nil, class: "fa fa-shopping-cart"
    when "Sell"
      h.content_tag :i, nil, class: "fa fa-money"
    end
  end
end
