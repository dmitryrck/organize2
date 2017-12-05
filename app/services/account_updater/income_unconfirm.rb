module AccountUpdater
  class IncomeUnconfirm < MovementBase
    private

    def final_balance
      @balance - @object.value
    end

    def flag_value
      false
    end
  end
end
