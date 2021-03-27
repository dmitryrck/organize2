class Outgo < Movement
  extend EnumerateIt

  belongs_to :card
  belongs_to :parent, class_name: 'Outgo'

  has_many :outgos, foreign_key: :parent_id

  has_enumeration_for :fee_kind

  def total
    value + (fee.presence || 0)
  end

  def summarize?
    chargeable_type != 'Card' && !confirmed?
  end

  def repeat_expense
    @repeat_expense || ""
  end

  def repeat_expense=(content)
    @repeat_expense = content
  end
end
