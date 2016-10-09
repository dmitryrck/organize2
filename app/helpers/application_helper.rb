module ApplicationHelper
  def numeric(value)
    precision = value < 0.01 ? 8 : 2

    number_to_currency(value, precision: precision)
  end
end
