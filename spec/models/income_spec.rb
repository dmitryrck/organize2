require 'rails_helper'

RSpec.describe Income, type: :model do
  subject { build(:income) }

  it_behaves_like Movement

  context "#summarize?" do
    context "when paid" do
      before { subject.paid = true }

      it { is_expected.not_to be_summarize }
    end

    context "when unpaid" do
      before { subject.paid = false }

      it { is_expected.to be_summarize }
    end
  end
end
