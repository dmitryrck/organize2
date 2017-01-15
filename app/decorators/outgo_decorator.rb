class OutgoDecorator < Draper::Decorator
  delegate_all

  delegate :precision, to: :chargeable, allow_nil: true

  def value
    h.number_to_currency(object.value, precision: precision)
  end

  def fee
    h.number_to_currency(object.fee, precision: precision)
  end

  def total
    if object.fee.blank? || object.fee.zero?
      h.number_to_currency(object.value, precision: precision)
    else
      h.content_tag :abbr, title: fee_title do
        h.number_to_currency(object.value, precision: precision)
      end
    end
  end

  private

  def fee_title
    if object.fee_kind.blank?
      h.number_to_currency(object.fee, precision: precision)
    else
      "#{object.fee_kind_humanize}: #{h.number_to_currency(object.fee, precision: precision)}"
    end
  end
end
