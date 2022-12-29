module AccountUpdater
  class ExchangeConfirm < TwoAccountsBase
    private

    def final_source_balance
      if fee_kind == ExchangeFeeKind::SOURCE
        @source_balance - @object.value_out - @object.fee
      else
        @source_balance - @object.value_out
      end
    end

    def final_destination_balance
      if fee_kind == ExchangeFeeKind::DESTINATION
        @destination_balance + @object.value_in - @object.fee
      else
        @destination_balance + @object.value_in
      end
    end
  end
end
