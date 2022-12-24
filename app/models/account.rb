class Account < ActiveRecord::Base
  validates :name, :start_balance, :balance, presence: true

  has_many :movements, as: :chargeable, dependent: :restrict_with_error
  has_many :outgos, as: :chargeable, dependent: :restrict_with_error
  has_many :incomes, as: :chargeable, dependent: :restrict_with_error

  scope :ordered, -> { order(:name) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  before_create do |account|
    account.balance = account.start_balance
  end

  def to_s
    name
  end

  def inactive?
    !active?
  end
end
