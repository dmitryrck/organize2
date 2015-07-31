require 'rails_helper'

RSpec.describe Account, type: :model do
  subject do
    Account.new name: 'Account#1'
  end

  it { is_expected.to be_valid }

  it 'should return name as to_s' do
    expect(subject.to_s).to eq 'Account#1'
  end

  it 'should not be invalid with no name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no start_balance' do
    subject.start_balance = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no balance' do
    subject.balance = nil
    expect(subject).to_not be_valid
  end
end
