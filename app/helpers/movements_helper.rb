module MovementsHelper
  def period?
    defined?(@period)
  end

  def table_color(movement)
    return :info if movement.chargeable_type == 'Card'
    return :success if movement.paid?
    :warning
  end

  def total(movement)
    if movement.fee.blank? || movement.fee.zero?
      numeric(movement.value)
    else
      content_tag :abbr, title: fee(movement) do
        numeric(movement.value)
      end
    end
  end

  private

  def fee(movement)
    return number_to_currency(movement.fee, precision: 8) if movement.fee_kind.blank?

    "#{movement.fee_kind_humanize}: #{number_to_currency(movement.fee, precision: 8)}"
  end
end
