class Trade < ActiveRecord::Base
  delegate :year, :month, to: :trade_at, allow_nil: true

  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'

  validates :source_id, :destination_id, :value_in, :value_out, :fee,
    :trade_at, :kind, presence: true

  scope :ordered, -> { order('trade_at desc') }
  scope :pending, -> { where(confirmed: false) }

  scope :by_period, lambda { |period|
    date = Date.new(period.year.to_i, period.month.to_i, 1)

    where('trade_at >= ? and trade_at <= ?', date.beginning_of_month, date.end_of_month)
  }

  def exchange_rate
    case kind
    when "Buy"
      value_out / value_in
    when "Sell"
      value_in / value_out
    end
  end
end
