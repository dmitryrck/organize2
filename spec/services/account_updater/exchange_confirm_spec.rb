require "rails_helper"

describe AccountUpdater::ExchangeConfirm do
  context "#confirm!" do
    subject { AccountUpdater::ExchangeConfirm.new(exchange) }

    context "when fee_kind is source" do
      let(:exchange) { create(:exchange, fee_kind: ExchangeFeeKind::SOURCE) }

      it { expect { subject.update! }.to change { exchange.destination.balance }.by(10) }
      it { expect { subject.update! }.to change { exchange.source.balance }.by(-21) }
    end

    context "when fee_kind is destination" do
      let(:exchange) { create(:exchange, fee_kind: ExchangeFeeKind::DESTINATION) }

      it { expect { subject.update! }.to change { exchange.destination.balance }.by(9) }
      it { expect { subject.update! }.to change { exchange.source.balance }.by(-20) }
    end
  end
end
