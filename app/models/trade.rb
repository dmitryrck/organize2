class Trade < ActiveRecord::Base
  delegate :year, :month, to: :trade_at, allow_blank: true

  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'

  validates :source_id, :destination_id, :value_in, :value_out, :fee,
    :trade_at, presence: true

  scope :ordered, -> { order('trade_at desc') }

  scope :by_period, lambda { |period|
    date = Date.new(period.year.to_i, period.month.to_i, 1)

    where('trade_at >= ? and trade_at <= ?', date.beginning_of_month, date.end_of_month)
  }

  def exchange_rate
    value_out/value_in
  end
end
