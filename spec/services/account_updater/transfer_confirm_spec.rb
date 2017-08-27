require 'rails_helper'

describe AccountUpdater::TransferConfirm do
  context '#confirm!' do
    subject { AccountUpdater::TransferConfirm.new(transfer) }
    let(:transfer) { create(:transfer) }

    context "when there is a fee" do
      it { expect { subject.update! }.to change { transfer.source.balance }.by(-11) }
      it { expect { subject.update! }.to change { transfer.destination.balance }.by(10) }
    end

    context "when there is no fee" do
      before { transfer.fee = nil }

      it { expect { subject.update! }.to change { transfer.source.balance }.by(-10) }
      it { expect { subject.update! }.to change { transfer.destination.balance }.by(10) }
    end
  end
end
