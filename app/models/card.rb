class Card < ActiveRecord::Base
  validates :name, presence: true

  scope :ordered, -> { order(:name) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  has_many :movements, as: :chargeable, dependent: :restrict_with_error

  def to_s
    name
  end

  def inactive?
    !active?
  end

  def kind_and_name
    "Card - #{name}"
  end
end
