class Movement < ActiveRecord::Base
  include Datable
  include Confirmable
  include Transactionable

  self.inheritance_column = :kind

  include PgSearch
  pg_search_scope :search, against: :description

  validates :description, :chargeable, :value, :date, presence: true
  validates :transaction_hash, uniqueness:
    { scope: [:chargeable_type, :chargeable_id] },
    allow_blank: true

  belongs_to :chargeable, polymorphic: true

  delegate :inactive?, to: :chargeable, allow_nil: true, prefix: true

  scope :card, -> { where(chargeable_type: "Card") }

  def regular_and_unpaid?
    regular? && !confirmed?
  end

  def regular_and_paid?
    regular? && confirmed?
  end

  def card?
    chargeable_type == "Card"
  end

  def duplicable_attributes
    hash = {}

    %i[
      description
      value
      kind
      category
      chargeable_id
      chargeable_type
      fee
      fee_kind
      card_id
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

  def unconfirmed?
    !confirmed?
  end

  private

  def regular?
    !card?
  end
end
