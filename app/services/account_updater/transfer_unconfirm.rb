module AccountUpdater
  class TransferUnconfirm < TwoAccountsBase
    private

    def final_source_balance
      @source_balance + @object.value + @object.fee
    end

    def final_destination_balance
      @destination_balance - @object.value
    end

    def flag_value
      false
    end
  end
end
