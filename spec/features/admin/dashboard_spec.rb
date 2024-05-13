require "rails_helper"

describe "Dashboard", type: :system do
  before do
    account.save
    create(:account, name: "Account#2", active: false)

    sign_in(user)
  end

  let(:account) { create(:account, start_balance: 100) }
  let(:account3) { create(:account, name: "Account#3") }
  let(:user) { create(:admin_user) }

  it "should show only active accounts with movements" do
    create(:outgo, chargeable: account, confirmed: false)
    create(:outgo, chargeable: account3, confirmed: true)

    click_on "Dashboard"

    expect(page).to have_content "Account#1 (Current balance: $100.00)"
    expect(page).not_to have_content "Account#2"
    expect(page).not_to have_content "Account#3"
  end

  context "when there are unpaid outgos" do
    before do
      create(:outgo, chargeable: account, date: Date.new(2019, 3, 1), value: 10)
      create(:outgo, chargeable: account, date: Date.new(2019, 3, 1), value: 5, confirmed: true)
      create(:income, chargeable: account, date: Date.new(2019, 3, 1), value: 3)
      create(:income, chargeable: account, date: Date.new(2019, 3, 1), value: 2, confirmed: true)
      create(:outgo, chargeable: account, date: Date.new(2019, 3, 10), value: 5)
      create(:outgo, chargeable: account, date: Date.new(2019, 3, 31), confirmed: true)

      click_on "Dashboard"
    end

    it "should show only the weeks of unpaid outgos" do
      expect(page).to have_content "2019-02-25 → 2019-03-03"
      expect(page).to have_content "2019-03-04 → 2019-03-10"
      expect(page).not_to have_content "2019-03-25 → 2019-03-31"
    end

    it "should calculate for the first week" do
      expect(find(:xpath, "//table/tbody/tr[1]/td[2]")).to have_content "$5.00"
      expect(find(:xpath, "//table/tbody/tr[1]/td[3]")).to have_content "$10.00"
      expect(find(:xpath, "//table/tbody/tr[1]/td[4]")).to have_content "$2.00"
      expect(find(:xpath, "//table/tbody/tr[1]/td[5]")).to have_content "$3.00"
      expect(find(:xpath, "//table/tbody/tr[1]/td[6]")).to have_content "$93.00"
    end

    it "should calculate for the second week" do
      expect(find(:xpath, "//table/tbody/tr[2]/td[2]")).to have_content "$0.00"
      expect(find(:xpath, "//table/tbody/tr[2]/td[3]")).to have_content "$5.00"
      expect(find(:xpath, "//table/tbody/tr[2]/td[4]")).to have_content "$0.00"
      expect(find(:xpath, "//table/tbody/tr[2]/td[5]")).to have_content "$0.00"
      expect(find(:xpath, "//table/tbody/tr[2]/td[6]")).to have_content "$88.00"
    end
  end
end
