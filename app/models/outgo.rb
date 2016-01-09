class Outgo < Movement
  extend EnumerateIt

  belongs_to :card

  has_enumeration_for :fee_kind

  def to_s
    "#{description} - #{value}"
  end

  def total
    value + fee
  end

  def summarize?
    chargeable_type != 'Card' && !paid?
  end
end
