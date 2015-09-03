class Account < ActiveRecord::Base
  validates :name, :start_balance, :balance, presence: true

  has_many :movements, as: :chargeable, dependent: :restrict_with_error

  scope :ordered, -> { order(:name) }

  def to_s
    name
  end
end
