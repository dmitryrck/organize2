module Transactionable
  extend ActiveSupport::Concern

  included do
    validates :transaction_hash, uniqueness: true, allow_blank: true

    before_validation do |record|
      record.transaction_hash = nil if record.transaction_hash.blank?
    end
  end
end
