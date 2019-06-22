require 'rails_helper'

RSpec.describe Movement, type: :model do
  subject { build(:outgo, chargeable: chargeable, chargeable_type: chargeable.class.name) }

  let(:chargeable) { build(:account) }

  it_behaves_like Movement

  context "#outgo?" do
    it { is_expected.to be_outgo }
  end

  context "#income?" do
    it { is_expected.not_to be_income }
  end

  context '#summarize?' do
    context 'with Account chargeable_type' do
      context "and confirmed" do
        before { subject.confirmed = true }

        it { expect(subject).not_to be_summarize }
      end

      context "and unconfirned" do
        before { subject.confirmed = false }

        it { expect(subject).to be_summarize }
      end
    end

    context 'with Card chargeable_type' do
      let(:chargeable) { build(:card) }

      context "and confirmed" do
        before { subject.confirmed = true }

        it { expect(subject).not_to be_summarize }
      end

      context "and unconfirned" do
        before { subject.confirmed = false }

        it { expect(subject).not_to be_summarize }
      end
    end
  end
end
