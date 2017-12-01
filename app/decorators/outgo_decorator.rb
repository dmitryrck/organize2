class OutgoDecorator < ApplicationDecorator
  delegate_all

  delegate :precision, :currency, to: :chargeable, allow_nil: true

  def description
    "#{icon} #{object.description} #{tag}".html_safe
  end

  def fee
    to_currency(object.fee, currency: currency, precision: precision)
  end

  def value
    to_currency(object.value, currency: currency, precision: precision)
  end

  def total
    if object.fee.blank? || object.fee.zero?
      value
    else
      h.content_tag :abbr, title: fee_title do
        value
      end
    end
  end

  private

  def fee_title
    if object.fee_kind.blank?
      to_currency(object.fee, currency: currency, precision: precision)
    else
      "#{object.fee_kind_humanize}: #{to_currency(object.fee, currency: currency, precision: precision)}"
    end
  end

  def icon
    h.content_tag(:i, nil, class: "fa fa-credit-card") if object.chargeable_type == "Card"
  end

  def tag
    return if object.category.blank?
    h.content_tag(:span, object.category, class: "status_tag info")
  end
end
