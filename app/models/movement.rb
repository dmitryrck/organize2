class Movement < ActiveRecord::Base
  self.inheritance_column = :kind

  validates :description, :account, :value, :paid_at, presence: true

  belongs_to :account

  scope :paid, -> {
    where(paid: true)
  }

  scope :unpaid, -> {
    where(paid: false)
  }
end
