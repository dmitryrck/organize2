require 'rails_helper'

describe Transfer do
  subject do
    Transfer.new(
      source: account1,
      destination: account2,
      value: 100,
      transfered_at: Date.current
    )
  end

  let :account1 do
    Account.new name: 'Account#1'
  end

  let :account2 do
    Account.new name: 'Account#2'
  end

  it { is_expected.to be_valid }

  it 'should not be valid with no source' do
    subject.source = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no destination' do
    subject.destination = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no value' do
    subject.value = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no transfered_at' do
    subject.transfered_at = nil
    expect(subject).not_to be_valid
  end
end
