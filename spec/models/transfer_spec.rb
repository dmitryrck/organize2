require 'rails_helper'

describe Transfer do
  subject { build(:transfer) }

  it { is_expected.to be_valid }

  it 'should not be valid with no source' do
    subject.source = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no destination' do
    subject.destination = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no value' do
    subject.value = nil
    expect(subject).not_to be_valid
  end

  it 'should not be valid with no transfered_at' do
    subject.transfered_at = nil
    expect(subject).not_to be_valid
  end
end
