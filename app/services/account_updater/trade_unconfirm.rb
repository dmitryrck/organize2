module AccountUpdater
  class TradeUnconfirm < TwoAccountsBase
    private

    def final_source_balance
      @source_balance + @object.value_out
    end

    def final_destination_balance
      @destination_balance - @object.value_in + @object.fee
    end

    def flag_value
      false
    end
  end
end
