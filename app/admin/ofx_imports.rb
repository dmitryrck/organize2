ActiveAdmin.register_page "OfxImports" do
  content do
    render partial: "new"
  end

  page_action :upload, method: :post do
    @ofx = OFX::Parser::Base.new(params[:ofx][:file].path).parser
    @accounts = Account.active
    @outgos = []
    @mappings = MovementRemapping.active.ordered

    @ofx.accounts.each do |ofx_account|
      bank_account = @accounts.select { |account| account.name.match(ofx_account.id) }[0]

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
          date: date, chargeable: bank_account,
        )

        Remapper.call(outgo, mappings: @mappings)

        @outgos.push(outgo.decorate)
      end
    end

    render :show, layout: "active_admin"
  end
end
