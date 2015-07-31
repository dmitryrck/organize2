class Movement < ActiveRecord::Base
  self.inheritance_column = :kind

  validates :description, :account, :value, :paid_at, presence: true

  belongs_to :account

  scope :ordered, -> {
    order("paid_at desc")
  }

  scope :paid, -> {
    where(paid: true)
  }

  scope :unpaid, -> {
    where(paid: false)
  }

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
end
