module MovementsHelper
  def table_color(movement)
    return :info if movement.chargeable_type == 'Card'
    return :success if movement.paid?
    :warning
  end

  def total(movement)
    value = movement.value

    precision = value < 0.01 ? 8 : 2

    currency = number_to_currency(value, precision: precision)

    if movement.fee.blank? || movement.fee.zero?
      currency
    else
      content_tag :abbr, title: fee(movement) do
        currency
      end
    end
  end

  private

  def fee(movement)
    return number_to_currency(movement.fee, precision: 8) if movement.fee_kind.blank?

    "#{movement.fee_kind_humanize}: #{number_to_currency(movement.fee, precision: 8)}"
  end
end
