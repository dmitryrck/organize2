module AccountUpdater
  class TradeUnconfirm < TwoAccountsBase
    def update!
      @object.transaction do
        @object.update_column(:confirmed, false)
        source.update_column(:balance, final_source_balance)
        destination.update_column(:balance, final_destination_balance)
      end
    end

    private

    def final_source_balance
      @source_balance + @object.value_out
    end

    def final_destination_balance
      @destination_balance - @object.value_in + @object.fee
    end
  end
end
