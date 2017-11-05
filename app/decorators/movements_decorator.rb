class MovementsDecorator < Draper::CollectionDecorator
  def regular_and_paid_count
    @paid_count ||= count(:regular_and_paid?)
  end

  def regular_and_paid_value
    value(:regular_and_paid?)
  end

  def regular_and_unpaid_count
    @unpaid_count ||= count(:regular_and_unpaid?)
  end

  def regular_and_unpaid_value
    value(:regular_and_unpaid?)
  end

  def card_count
    @card_count ||= count(:card?)
  end

  def card_value
    value(:card?)
  end

  private

  def count(symbol)
    object.select(&symbol).count
  end

  def value(symbol)
    object.select(&symbol).sum do |movement|
      return movement.object.value if movement.object.fee.nil?

      movement.object.value + movement.object.fee
    end
  end
end
