class Exchange < ActiveRecord::Base
  extend EnumerateIt

  include Datable
  include Confirmable
  include Transactionable

  belongs_to :source, class_name: "Account"
  belongs_to :destination, class_name: "Account"

  validates :source_id, :destination_id, :value_in, :value_out, :fee,
    :date, :kind, presence: true

  has_enumeration_for :kind, with: ExchangeKind

  def to_s
    "#{self.class.model_name.human}##{id}"
  end

  def exchange_rate
    return 0.0 if value_out.zero? || value_in.zero?

    case kind
    when ExchangeKind::BUY
      value_out / value_in
    when ExchangeKind::SELL
      value_in / value_out
    end
  end
end
