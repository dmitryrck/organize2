class Movement < ActiveRecord::Base
  self.inheritance_column = :kind

  include PgSearch
  pg_search_scope :search, against: :description

  validates :description, :chargeable, :value, :paid_at, presence: true
  validates :transaction_hash, uniqueness:
    { scope: [:chargeable_type, :chargeable_id] },
    allow_blank: true

  belongs_to :chargeable, polymorphic: true

  delegate :inactive?, to: :chargeable, allow_nil: true, prefix: true

  scope :ordered, -> { order('paid_at desc') }
  scope :paid, -> { where(paid: true) }
  scope :unpaid, -> { where(paid: false) }
  scope :pending, -> { unpaid }

  scope :by_period, lambda { |period|
    date = Date.new(period.year.to_i, period.month.to_i, 1)

    where('paid_at >= ? and paid_at <= ?', date.beginning_of_month, date.end_of_month)
  }

  def year
    paid_at.year
  end

  def month
    paid_at.month
  end

  def unpaid?
    !paid?
  end

  def regular_and_unpaid?
    regular? && !paid?
  end

  def regular_and_paid?
    regular? && paid?
  end

  def card?
    chargeable_type == "Card"
  end

  def duplicable_attributes
    hash = {}

    [
      :description,
      :value,
      :paid,
      :kind,
      :category,
      :chargeable_id,
      :chargeable_type,
    ].each do |att|
      hash[att] = send(att)
    end

    hash
  end

  def total
    value
  end

  def related_value
    return value if kind == 'Income'
    return value * (-1)
  end

  private

  def regular?
    !card?
  end
end
