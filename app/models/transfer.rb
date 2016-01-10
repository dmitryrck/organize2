class Transfer < ActiveRecord::Base
  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'

  validates :value, :source, :destination, :transfered_at, presence: true

  scope :ordered, -> { order('transfered_at desc') }

  scope :by_period, lambda { |period|
    date = Date.new(period.year.to_i, period.month.to_i, 1)

    where('transfered_at >= ? and transfered_at <= ?', date.beginning_of_month, date.end_of_month)
  }

  def year
    transfered_at.year
  end

  def month
    transfered_at.month
  end
end
