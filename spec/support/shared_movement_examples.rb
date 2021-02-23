shared_examples_for Movement do
  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:regular_and_paid?) }
  it { is_expected.to respond_to(:regular_and_unpaid?) }
  it { is_expected.to respond_to(:outgo?) }
  it { is_expected.to respond_to(:income?) }

  it 'should not be invalid with no chargeable' do
    subject.chargeable = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no date' do
    subject.date = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no value' do
    subject.value = nil
    expect(subject).to_not be_valid
  end

  context "unconfirmed?" do
    context 'when it is confirmed' do
      before { subject.confirmed = true }

      it { is_expected.not_to be_unconfirmed }
    end

    context "when it is unconfirmed" do
      before { subject.confirmed = false }

      it { is_expected.to be_unconfirmed }
    end
  end

  context "#to_s" do
    it "should return description" do
      subject.description = "Description#1"
      expect(subject.to_s).to eq "Description#1"
    end
  end

  context "#not_in_reports?" do
    context "when object is in_reports?" do
      subject { build(:outgo, in_reports: true) }

      it { is_expected.not_to be_not_in_report }
    end

    context "when object is not in_reports?" do
      subject { build(:outgo, in_reports: false) }

      it { is_expected.to be_not_in_report }
    end
  end
end
