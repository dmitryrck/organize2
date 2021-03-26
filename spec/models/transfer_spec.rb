require 'rails_helper'

describe Transfer do
  subject { build(:transfer) }

  it_behaves_like BetweenAccounts

  it { is_expected.to be_valid }

  context "transaction hash" do
    context "when there is other transfer with a transaction_hash" do
      before { create(:transfer, transaction_hash: "a") }

      it "should not be valid with duplicated" do
        subject.transaction_hash = "a"
        expect(subject).not_to be_valid
      end
    end

    context "when there is other transfer with an empty transaction_hash" do
      before { create(:transfer, transaction_hash: "") }

      it "should not be valid with duplicated" do
        subject.transaction_hash = ""
        expect(subject).to be_valid
      end

      it "should not be valid with duplicated" do
        subject.transaction_hash = ""

        expect { subject.save }.to change { Transfer.count }.by(1)
      end
    end
  end

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

  it 'should not be valid with no date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it "#to_s" do
    subject.id = 9000
    expect(subject.to_s).to eq "Transfer#9000"
  end
end
