class Outgo < Movement
  extend EnumerateIt

  belongs_to :card
  belongs_to :parent, class_name: 'Outgo'

  has_many :outgos, foreign_key: :parent_id

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
