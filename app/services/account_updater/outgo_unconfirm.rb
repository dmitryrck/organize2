module AccountUpdater
  class OutgoUnconfirm < MovementBase
    private

    def final_balance
      @balance + @object.total
    end

    def flag_value
      false
    end
  end
end
