require 'rails_helper'

describe AccountDecorator do
  subject { account.decorate }

  let(:account) { build(:account, balance: 10, start_balance: 100, precision: 3) }

  context "when account has no currency" do
    describe ".balance" do
      it { expect(subject.balance).to eq "$10.000" }
    end

    describe ".start_balance" do
      it { expect(subject.start_balance).to eq "$100.000" }
    end
  end

  context "when account has currency" do
    before { account.currency = "BRL" }

    describe ".balance" do
      it { expect(subject.balance).to eq "BRL10.000" }
    end

    describe ".start_balance" do
      it { expect(subject.start_balance).to eq "BRL100.000" }
    end
  end
end
