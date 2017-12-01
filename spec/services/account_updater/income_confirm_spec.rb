require "rails_helper"

describe AccountUpdater::IncomeConfirm do
  context "#confirm!" do
    subject { AccountUpdater::IncomeConfirm.new(income) }
    let(:income) { create(:income, value: 10) }
    let(:account) { income.chargeable }

    it { expect { subject.update! }.to change { account.balance }.by(10) }
  end
end
