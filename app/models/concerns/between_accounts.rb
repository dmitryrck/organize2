module BetweenAccounts
  extend ActiveSupport::Concern

  included do
    validate :valid_source_and_destination

    private

    def valid_source_and_destination
      return if source.blank? || destination.blank?

      if source == destination
        errors.add(:destination, :other_than, count: source.to_s)
      end
    end
  end
end
