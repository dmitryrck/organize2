class CardDecorator < Draper::Decorator
  delegate_all

  def limit
    h.number_to_currency(object.limit, precision: precision)
  end
end
