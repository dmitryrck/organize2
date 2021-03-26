shared_examples_for BetweenAccounts do
  context "when source and destination are the same" do
    let(:account) { build(:account) }

    before { subject.source = subject.destination = account }

    it { expect(subject).not_to be_valid }
  end
end
