class AccountSummarizer
  def self.accounts
    new.accounts
  end

  def accounts
    @accounts ||= currencies.map do |currency|
      [
        currency,
        Account.where(currency: currency).sum(:balance),
      ]
    end.reject do |currency, balance|
      balance == 0
    end
  end

  private

  def currencies
    @currencies ||= Account.pluck(:currency).uniq
  end
end
