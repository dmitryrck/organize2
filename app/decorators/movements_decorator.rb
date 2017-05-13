class MovementsDecorator < Draper::CollectionDecorator
  def paid_count
    count(:summarize?)
  end

  def paid_value
    value(:summarize?)
  end

  def unpaid_count
    count(:unsummarize?)
  end

  def unpaid_value
    value(:unsummarize?)
  end

  private

  def count(symbol)
    object.select(&symbol).count
  end

  def value(symbol)
    object.select(&symbol).sum { |movement| movement.source.value + movement.source.fee }
  end
end
