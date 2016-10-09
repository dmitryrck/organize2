module AccountUpdater
  class TransferUnconfirm < TwoAccountsBase
    def update!
      @object.transaction do
        @object.update_column(:transfered, false)
        source.update_column(:balance, final_source_balance)
        destination.update_column(:balance, final_destination_balance)
      end
    end

    private

    def final_source_balance
      @source_balance + @object.value + @object.fee
    end

    def final_destination_balance
      @destination_balance - @object.value
    end
  end
end
