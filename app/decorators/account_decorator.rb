class AccountDecorator < ApplicationDecorator
  delegate_all

  def name
    [icon, object.name].reject(&:blank?).join(" ").html_safe
  end

  def balance
    to_currency(object.balance, currency: currency, precision: precision)
  end

  def start_balance
    to_currency(object.start_balance, currency: currency, precision: precision)
  end

  private

  def icon
    h.content_tag(:i, nil, class: "fa fa-credit-card") if object.card?
  end
end
