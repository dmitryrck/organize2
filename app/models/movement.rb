class Movement < ActiveRecord::Base
  include Datable
  include Confirmable
  include Transactionable

  self.inheritance_column = :kind

  def self.ransackable_attributes(auth_object = nil)
    %w[
      category
      chargeable
      chargeable_id
      confirmed
      date
      description
      expected_movement
      paid_to
      transaction_hash
      value
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  validates :description, :chargeable, :value, :date, presence: true
  validates :chargeable_id, presence: true, if: proc { |record| record.chargeable.blank? }
  validates :transaction_hash, uniqueness:
    { scope: [:chargeable_type, :chargeable_id] },
    allow_blank: true

  belongs_to :chargeable, polymorphic: true
  belongs_to :admin_user

  delegate :inactive?, to: :chargeable, allow_nil: true, prefix: true
  delegate :currency, to: :chargeable, allow_nil: true
  delegate :card?, to: :chargeable, allow_nil: true

  scope :unpaid, -> { where(confirmed: false) }
  scope :paid, -> { where(confirmed: true) }

  before_validation do |record|
    record.chargeable_type = "Account"
  end

  def unexpected_movement?
    !expected_movement?
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
      parent_id
      paid_to
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

  def income?
    is_a?(Income)
  end

  def outgo?
    is_a?(Outgo)
  end

  def to_s
    [
      unexpected_movement_flag,
      formatted_paid_to,
      description,
    ].reject(&:blank?).join(" ")
  end

  def unexpected_movement_flag
    "×" if unexpected_movement?
  end

  def formatted_paid_to
    "[#{paid_to}]" if paid_to.present?
  end
end
