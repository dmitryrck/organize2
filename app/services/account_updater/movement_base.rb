module AccountUpdater
  class MovementBase
    def initialize(object)
      @object = object
      @balance = object.chargeable.balance
    end

    def update!
      @object.transaction do
        @object.update_column(:confirmed, flag_value)
        if @object.respond_to?(:outgos)
          outgos.update_all(confirmed: flag_value)
        end

        chargeable.update_column(:balance, final_balance)
      end
    end

    def self.update!(object)
      new(object).update!
    end

    private

    delegate :chargeable, :outgos, to: :@object

    # :nocov:
    def final_source_balance
      fail "Not implemented"
    end

    def final_destination_balance
      fail "Not implemented"
    end
    # :nocov:

    def flag_value
      true
    end
  end
end
