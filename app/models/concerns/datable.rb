module Datable
  extend ActiveSupport::Concern

  included do
    delegate :year, :month, to: :date, allow_nil: true

    scope :by_period, lambda { |period|
      date = Date.new(period.year.to_i, period.month.to_i, 1)

      where("date >= ? and date <= ?", date.beginning_of_month, date.end_of_month)
    }

    scope :ordered, -> { order("date desc") }
  end
end
