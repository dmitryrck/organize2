require 'rails_helper'

RSpec.describe Income, type: :model do
  subject do
    Income.new description: 'Income#1',
      value: 100,
      paid_at: Date.current,
      account: account
  end

  let :account do
    Account.new name: 'Account#1', start_balance: 10
  end

  it { is_expected.to be_valid }

  it 'should not be invalid with no account' do
    subject.account = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no paid_at' do
    subject.paid_at = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no value' do
    subject.value = nil
    expect(subject).to_not be_valid
  end
end
