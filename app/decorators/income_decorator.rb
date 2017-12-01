class IncomeDecorator < ApplicationDecorator
  delegate_all

  delegate :precision, :currency, to: :chargeable, allow_nil: true

  def description
    "#{object.description} #{tag}".html_safe
  end

  def value
    to_currency(object.value, currency: currency, precision: precision)
  end

  def total
    to_currency(object.value, currency: currency, precision: precision)
  end

  private

  def tag
    return if object.category.blank?
    h.content_tag(:span, object.category, class: "status_tag info")
  end
end
