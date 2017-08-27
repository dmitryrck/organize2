require "rails_helper"

describe "Transfers" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  it "should be able to create" do
    Account.create name: 'Account#1'
    Account.create name: 'Account#2'

    click_on "Transfers"
    click_on "New"

    select "Account#1", from: "Source"
    select "Account#2", from: "Destination"
    expect(page).to have_field "Date", with: Date.current
    fill_in "Value", with: "100"

    click_on "Create"

    expect(page).to have_content "Transfer was successfully created."

    expect(page).to have_content("SOURCE Account#1") &
      have_content("DESTINATION Account#2") &
      have_content("VALUE $100.0")
  end

  context "when there is a transfer" do
    let!(:transfer) { create(:transfer) }

    it "should be able to update" do
      click_on "Transfer"
      within "#transfer_#{transfer.id}" do
        click_on "Edit"
      end

      fill_in "Value", with: "100"

      click_on "Update"

      expect(page).to have_content("100.0")
    end

    it "should block value and fee input if confirmed" do
      transfer.update_column(:confirmed, true)

      click_on "Transfer"
      within "#transfer_#{transfer.id}" do
        click_on "Edit"
      end

      expect(page).to have_field "Value", disabled: true
      expect(page).to have_field "Fee", disabled: true
    end

    it "should be able to comment" do
      click_on "Transfers"
      within "#transfer_#{transfer.id}" do
        click_on "View"
      end

      fill_in "active_admin_comment[body]", with: "Comment#1"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content("Comment#1") &
          have_content("admin@example.com")
      end
    end

    it "should link to a new form" do
      click_on "Transfers"
      within "#transfer_#{transfer.id}" do
        click_on "View"
      end

      expect(page).to have_link "New Transfer"
    end

    it "should be able to destroy" do
      click_on "Transfer"
      within "#transfer_#{transfer.id}" do
        click_on "Delete"
      end

      expect(page).not_to have_content("Account#1")
    end
  end
end
