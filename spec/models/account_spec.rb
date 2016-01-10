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

  context 'inactive?' do
    context 'when it is active' do
      before do
        subject.active = true
      end

      it { is_expected.not_to be_inactive }
    end

    context 'when it is inactive' do
      before do
        subject.active = false
      end

      it { is_expected.to be_inactive }
    end
  end
end
