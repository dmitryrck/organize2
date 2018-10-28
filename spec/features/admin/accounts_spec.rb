require "rails_helper"

describe "Accounts" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  context "index" do
    before do
      create(:account, name: "Account#1", currency: "BRL", start_balance: 100.0, precision: 4, active: true)
      create(:account, name: "Account#2", currency: "USD", start_balance: 10.0, active: false)
      create(:account, name: "Account#3", currency: nil, start_balance: 1.0, active: false)

      click_on "Accounts"
    end

    it "should filter by active" do
      click_on "Active"
      expect(page).to have_content "Account#1"
    end

    it "should filter by inactive" do
      click_on "Inactive"
      expect(page).to have_content "Account#2"
    end

    it "should show balances" do
      expect(page).to have_content("BRL100.0000")
      expect(page).to have_content("USD10.0")
      expect(page).to have_content("$1.0")
    end
  end

  it "should be able to create" do
    click_on "Accounts"
    click_on "New"

    fill_in "Name", with: "Account#1"
    fill_in "Start balance", with: 123.45
    fill_in "Currency", with: "USD"
    fill_in "Precision", with: 4

    click_on "Create"

    expect(page).to have_content("Account#1")
    expect(page).to have_content("START BALANCE USD123.45")
    expect(page).to have_content("BALANCE USD123.45")
    expect(page).to have_content("ACTIVE YES")
    expect(page).to have_content("PRECISION 4")

    expect(page).not_to have_content("BALANCE USD0.0")
  end

  context "when there is an account" do
    let!(:account) { create(:account) }

    it "should be able to update" do
      click_on "Accounts"
      within "#account_#{account.id}" do
        click_on "Edit"
      end

      fill_in "Name", with: "Account#2"
      fill_in "Currency", with: "BRL"

      click_on "Update"

      expect(page).to have_content("Account#2")
      expect(page).to have_content("BRL")
    end

    it "should be able to comment" do
      click_on "Accounts"
      within "#account_#{account.id}" do
        click_on "View"
      end

      fill_in "active_admin_comment[body]", with: "Comment#1"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content("Comment#1")
        expect(page).to have_content("admin@example.com")
      end
    end

    it "should be able to destroy" do
      click_on "Accounts"
      within "#account_#{account.id}" do
        click_on "Delete"
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_content("Account#1")
    end
  end
end
