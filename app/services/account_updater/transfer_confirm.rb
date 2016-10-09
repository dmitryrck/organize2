module AccountUpdater
  class TransferConfirm < TwoAccountsBase
    private

    def final_source_balance
      @source_balance - (@object.value + @object.fee)
    end

    def final_destination_balance
      @destination_balance + @object.value
    end
  end
end
