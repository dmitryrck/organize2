shared_examples_for Movement do
  it { is_expected.to be_valid }
  it { is_expected.to respond_to(:outgo?) }
  it { is_expected.to respond_to(:income?) }

  it 'should not be invalid with no chargeable' do
    subject.chargeable = nil
    expect(subject).to_not be_valid
  end

  it "is not be valid with no chargeable_id and chargeable" do
    subject.chargeable_id = nil
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
    context "when there is no paid_to" do
      before { subject.description = "Description#1" }

      it do
        expect(subject.to_s).to eq "Description#1"
      end
    end

    context "when there is paid_to" do
      before do
        subject.paid_to = "Company"
        subject.description = "Description#1"
      end

      it do
        expect(subject.to_s).to eq "[Company] Description#1"
      end
    end

    context "when it is an unexpected expense" do
      context "and paid_to" do
        before do
          subject.expected_movement = false
          subject.paid_to = "Company"
          subject.description = "Description#1"
        end

        it do
          expect(subject.to_s).to eq "× [Company] Description#1"
        end
      end

      context "and no paid_to" do
        before do
          subject.expected_movement = false
          subject.description = "Description#1"
        end

        it do
          expect(subject.to_s).to eq "× Description#1"
        end
      end
    end
  end

  context "#unexpected_movement_flag" do
    context "when it is expected" do
      before { subject.expected_movement = true }

      it { expect(subject.unexpected_movement_flag).to be_blank }
    end

    context "when it is not expected" do
      before { subject.expected_movement = false }

      it { expect(subject.unexpected_movement_flag).to eq "×" }
    end
  end

  context "#formatted_paid_to" do
    context "when there is no paid_to" do
      before { subject.paid_to = "" }

      it { expect(subject.formatted_paid_to).to be_blank }
    end

    context "when there is paid_to" do
      before { subject.paid_to = "Market" }

      it { expect(subject.formatted_paid_to).to eq "[Market]" }
    end
  end

  context "#unexpected_movement?" do
    context "when object is expected_movement?" do
      subject { build(:outgo, expected_movement: true) }

      it { is_expected.not_to be_unexpected_movement }
    end

    context "when object is not expected_movement?" do
      subject { build(:outgo, expected_movement: false) }

      it { is_expected.to be_unexpected_movement }
    end
  end
end
