class CardDecorator < ApplicationDecorator
  delegate_all

  def limit
    to_currency(object.limit, currency: currency, precision: precision)
  end
end
