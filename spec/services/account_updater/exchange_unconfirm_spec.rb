require "rails_helper"

describe AccountUpdater::ExchangeConfirm do
  context "#confirm!" do
    subject { AccountUpdater::ExchangeUnconfirm.new(exchange) }

    let(:exchange) { create(:exchange, fee_kind: fee_kind) }

    context "when fee_kind is source" do
      let(:fee_kind) { ExchangeFeeKind::SOURCE }

      it { expect { subject.update! }.to change { exchange.source.balance }.by(21) }
      it { expect { subject.update! }.to change { exchange.destination.balance }.by(-10) }
    end

    context "when fee_kind is destination" do
      let(:fee_kind) { ExchangeFeeKind::DESTINATION }

      it { expect { subject.update! }.to change { exchange.source.balance }.by(20) }
      it { expect { subject.update! }.to change { exchange.destination.balance }.by(-9) }
    end
  end
end
