require "rails_helper"

describe AccountUpdater::IncomeUnconfirm do
  context "#confirm!" do
    subject { AccountUpdater::IncomeUnconfirm.new(income) }
    let(:income) { create(:income, value: 10, confirmed: true) }
    let(:account) { income.chargeable }

    it { expect { subject.update! }.to change { account.balance }.by(-10) }
    it { expect { subject.update! }.to change { income.reload.confirmed? }.to(false) }
  end
end
