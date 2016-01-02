class Outgo < Movement
  belongs_to :card

  def to_s
    "#{description} - #{value}"
  end

  def total
    value
  end

  def summarize?
    chargeable_type != 'Card' && !paid?
  end
end
