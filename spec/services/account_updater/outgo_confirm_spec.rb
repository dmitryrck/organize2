require "rails_helper"

describe AccountUpdater::OutgoConfirm do
  context '#confirm!' do
    subject { AccountUpdater::OutgoConfirm.new(outgo) }
    let(:outgo) { create(:outgo, value: 10, fee: 1) }
    let(:account) { outgo.chargeable }

    context "when there is a fee" do
      it { expect { subject.update! }.to change { account.balance }.by(-11) }
    end

    context "when there is no fee" do
      before { outgo.fee = nil }

      it { expect { subject.update! }.to change { account.balance }.by(-10) }
    end
  end
end
