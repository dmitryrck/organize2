require 'rails_helper'

describe AccountUpdater::TransferConfirm do
  context '#confirm!' do
    subject { AccountUpdater::TransferConfirm.new(transfer) }

    let(:transfer) { create(:transfer) }

    it { expect { subject.update! }.to change { transfer.source.balance }.by(-11) }
    it { expect { subject.update! }.to change { transfer.destination.balance }.by(10) }
  end
end
