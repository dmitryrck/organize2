class ExchangeRate < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[
      destination
      market
      source
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
