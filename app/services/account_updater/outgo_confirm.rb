module AccountUpdater
  class OutgoConfirm < MovementBase
    private

    def final_balance
      @balance - @object.total
    end
  end
end
