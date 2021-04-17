class Category < ApplicationRecord
  self.primary_key = "name"

  after_initialize :readonly!

  def summary
    @summary ||= summary_query
      .group_by { |summary| "#{summary.month} (#{summary.currency})" }
      .map do |month_currency, value|
        expected_movement = value.detect { |summary| summary.expected_movement }
        unexpected_movement = value.detect { |summary| !summary.expected_movement }

        {
          month_currency: month_currency,
          expected_movement: (expected_movement.present? ? expected_movement.sum : 0),
          unexpected_movement: (unexpected_movement.present? ? unexpected_movement.sum : 0),
        }
      end
  end

  def one_year_ago
    @one_year_ago ||= 1.year.ago.to_date.beginning_of_month
  end

  private

  def summary_query
    @summary_query ||= CategorySummary.where(name: name).where("month >= ?", one_year_ago)
  end
end
