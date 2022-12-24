class Outgo < Movement
  extend EnumerateIt

  validate :valid_parent

  belongs_to :parent, class_name: 'Outgo'

  has_many :outgos, foreign_key: :parent_id

  has_enumeration_for :fee_kind

  def total
    value + (fee.presence || 0)
  end

  def repeat_expense
    @repeat_expense || ""
  end

  def repeat_expense=(content)
    @repeat_expense = content
  end

  private

  def valid_parent
    return if parent_id.blank?

    if Movement.where(id: parent_id).none?
      errors.add(:parent_id, :required)
    end
  end
end
