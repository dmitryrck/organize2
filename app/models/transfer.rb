class Transfer < ActiveRecord::Base
  include BetweenAccounts
  include Confirmable
  include Datable
  include Transactionable

  belongs_to :source, class_name: 'Account'
  belongs_to :destination, class_name: 'Account'

  validates :value, :source, :destination, :date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      confirmed
      date
      destination_id
      source_id
      transaction_hash
      value
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def to_s
    "#{self.class.model_name.human}##{id}"
  end
end
