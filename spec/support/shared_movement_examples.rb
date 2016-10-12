shared_examples_for Movement do
  it { is_expected.to be_valid }

  it 'should not be invalid with no chargeable' do
    subject.chargeable = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no paid_at' do
    subject.paid_at = nil
    expect(subject).to_not be_valid
  end

  it 'should not be invalid with no value' do
    subject.value = nil
    expect(subject).to_not be_valid
  end

  context 'unpaid?' do
    context 'when it is paid' do
      before do
        subject.paid = true
      end

      it { is_expected.not_to be_unpaid }
    end

    context 'when it is unpaid' do
      before do
        subject.paid = false
      end

      it { is_expected.to be_unpaid }
    end
  end
end
