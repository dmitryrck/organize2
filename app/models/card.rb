class Card < ActiveRecord::Base
  validates :name, presence: true

  scope :ordered, -> { order(:name) }

  has_many :movements, as: :chargeable, dependent: :restrict_with_error

  def to_s
    name
  end
end
