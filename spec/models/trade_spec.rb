require 'rails_helper'

RSpec.describe Trade, type: :model do
  subject { build(:trade) }

  it { is_expected.to be_valid }

  it 'should not be valid with no source' do
    subject.source = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no kind' do
    subject.kind = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no destionation' do
    subject.destination = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no value_in' do
    subject.value_in = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no value_out' do
    subject.value_out = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no fee' do
    subject.fee = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no trade_at' do
    subject.trade_at = nil
    expect(subject).not_to be_valid
  end

  context "#exchange_rate" do
    context "when it is a buy" do
      it "should return correct value" do
        subject.kind = "Buy"
        subject.value_out = 20
        subject.value_in = 10

        expect(subject.exchange_rate).to eq 2
      end
    end

    context "when it is a sell" do
      it "should return correct value" do
        subject.kind = "Sell"
        subject.value_out = 10
        subject.value_in = 20

        expect(subject.exchange_rate).to eq 2
      end
    end
  end
end
