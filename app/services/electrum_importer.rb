require 'csv'

class ElectrumImporter
  def initialize(csv_path: , account:)
    @csv_path = csv_path
    @account = account
  end

  def import!
    balance = @account.balance

    @account.transaction do
      CSV.foreach(@csv_path, col_sep: ',') do |row|
        next if row.include?('label')

        movement = Movement.find_or_initialize_by(
          transaction_hash: row[0],
          chargeable: @account
        )
        movement.description = row[1]
        movement.value = row[3][1..-1].to_f
        movement.paid_at = row[4]
        movement.kind = row[3][0] == '+' ? 'Income' : 'Outgo'
        movement.paid = true

        if movement.new_record?
          balance += movement.related_value
        end

        movement.save
      end

      @account.update_column(:balance, balance)
    end
  end
end
