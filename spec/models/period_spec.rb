require 'spec_helper'

describe Period do
  subject do
    Period.new(2012, 11)
  end

  it 'should respond to year' do
    expect(subject.year).to eq '2012'
  end

  it 'should respond to month' do
    expect(subject.month).to eq '11'
  end

  it 'should store year as string' do
    subject.year = 2012
    expect(subject.year).to eq '2012'
  end

  it 'should return month with two digits' do
    subject.month = 8
    expect(subject.month).to eq '08'
  end

  it 'should fix compare when use ==' do
    other = Period.new(2012, 11)
    expect(subject).to eq other
  end

  it 'should return to_s as year-month' do
    expect(subject.to_s).to eq '2012-11'
  end

  context 'next' do
    it 'should return next period' do
      next_period = Period.new(2012, 12)
      expect(subject.next).to eq next_period
    end

    it 'should return 1 as next period at end of year' do
      period = Period.new(2012, 12)
      next_period = Period.new(2013, 1)
      expect(period.next).to eq next_period
    end
  end

  context 'previous' do
    it 'should return previous period' do
      expect(subject.previous).to eq Period.new(2012, 10)
    end

    it 'should return 12 as next period at beginging of year' do
      period = Period.new(2012, 1)
      previous_period = Period.new(2011, 12)
      expect(period.previous).to eq previous_period
    end
  end
end
