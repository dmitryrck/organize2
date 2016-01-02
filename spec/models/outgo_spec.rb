require 'rails_helper'

RSpec.describe Movement, type: :model do
  subject do
    Outgo.new description: 'Movement#1',
      value: 100,
      paid_at: Date.current,
      chargeable: account
  end

  let :account do
    Account.new name: 'Account#1', start_balance: 10
  end

  context '#summarize?' do
    context 'with Account chargeable_type' do
      before { subject.chargeable_type = 'Account' }

      context 'and paid' do
        before { subject.paid = true }

        it { expect(subject).not_to be_summarize }
      end

      context 'and unpaid' do
        before { subject.paid = false }

        it { expect(subject).to be_summarize }
      end
    end

    context 'with Card chargeable_type' do
      before { subject.chargeable_type = 'Card' }

      context 'and paid' do
        before { subject.paid = true }

        it { expect(subject).not_to be_summarize }
      end

      context 'and unpaid' do
        before { subject.paid = false }

        it { expect(subject).not_to be_summarize }
      end
    end
  end
end
