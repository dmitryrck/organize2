require "rails_helper"

describe AccountSummarizer do
  before do
    Account.create(name: "Account#1", balance: 12, currency: "BRL")
    Account.create(name: "Account#2", balance: 34, currency: "BRL")
    Account.create(name: "Account#3", balance: 10, currency: "USD")
    Account.create(name: "Account#4", balance:  0, currency: "EUR")
  end

  subject { AccountSummarizer }

  it "should resume information for BRL" do
    expect(subject.accounts).to include(["BRL", 46])
  end

  it "should resume information for USD" do
    expect(subject.accounts).to include(["USD", 10])
  end

  it "should not resume information for EUR" do
    expect(subject.accounts).not_to include(["EUR", 0])
  end
end
