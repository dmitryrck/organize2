module AccountUpdater
  class TradeUnconfirm
    def initialize(trade: )
      @trade = trade
      @source_balance = trade.source.balance
      @destination_balance = trade.destination.balance
    end

    def update!
      @trade.transaction do
        @trade.update_column(:confirmed, false)
        source.update_column(:balance, final_source_balance)
        destination.update_column(:balance, final_destination_balance)
      end
    end

    def self.update!(trade)
      new(trade: trade).update!
    end

    private

    delegate :source, :destination, to: :@trade

    def final_source_balance
      @source_balance + @trade.value_out
    end

    def final_destination_balance
      @destination_balance - @trade.value_in + @trade.fee
    end
  end
end
