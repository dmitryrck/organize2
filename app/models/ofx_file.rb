class OfxFile < ApplicationRecord
  validates :content, presence: true

  def bank_ids
    @bank_idx ||= ofx.accounts.map { |ofx_account| ofx_account.id }
  end

  def outgos
    @outgos = []

    ofx.accounts.each do |ofx_account|
      bank_account = accounts.select { |account| account.name.match(ofx_account.id) }[0]

      ofx_account.transactions.each do |transaction|
        next if transaction.memo.match(%r[transfer]i)
        next unless ["debit", :debit].include?(transaction.type)

        value = (-1 * transaction.amount.to_f)
        date = transaction.posted_at.strftime("%F")

        if bank_account.present?
          current_outgo = Outgo.where(chargeable: bank_account, value: value, date: date)
          outgo = current_outgo[0] if current_outgo.size == 1
        end

        outgo ||= Outgo.new(
          paid_to: transaction.memo,
          description: transaction.name,
          value: value,
          date: date,
          chargeable: bank_account,
        )

        if outgo.new_record?
          Remapper.call(outgo, mappings: mappings)
        end

        @outgos.push(outgo.decorate)
      end
    end

    @outgos
  end

  private

  def ofx
    @ofx ||= OFX::Parser::Base.new(content).parser
  end

  def accounts
    @accounts ||= Account.active
  end

  def mappings
    @mappings ||= MovementRemapping.active.ordered
  end
end
