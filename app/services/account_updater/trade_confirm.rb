module AccountUpdater
  class TradeConfirm < TwoAccountsBase
    private

    def final_source_balance
      @source_balance - @object.value_out
    end

    def final_destination_balance
      @destination_balance + @object.value_in - @object.fee
    end
  end
end
