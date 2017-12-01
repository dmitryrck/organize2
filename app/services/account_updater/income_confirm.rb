module AccountUpdater
  class IncomeConfirm < MovementBase
    private

    def final_balance
      @balance + @object.value
    end
  end
end
