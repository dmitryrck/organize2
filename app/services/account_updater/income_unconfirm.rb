module AccountUpdater
  class IncomeUnconfirm < MovementBase
    private

    def final_balance
      @balance - @object.value
    end
  end
end
