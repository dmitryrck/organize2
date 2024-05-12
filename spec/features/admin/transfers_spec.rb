require "rails_helper"

describe "Transfers", type: :system do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  context "when there are transfers" do
    let(:last_month) { Date.current.last_month }
    let(:next_month) { Date.current.next_month }

    it "paginates by month" do
      prev_transfer = create(:transfer, date: Date.new(last_month.year, last_month.month, 15))
      curr_transfer = create(:transfer, date: Date.current)
      next_transfer = create(:transfer, date: Date.new(next_month.year, next_month.month, 15))

      click_on "Transfers"
      click_on "Previous month"
      expect(page).to have_link "View"
      within("table") { expect(page).to have_content prev_transfer.id }

      click_on "Next month"
      expect(page).to have_link "View"
      within("table") { expect(page).to have_content curr_transfer.id }

      click_on "Next month"
      expect(page).to have_link "View"
      within("table") { expect(page).to have_content next_transfer.id }

      click_on "Next month"
      expect(page).not_to have_link "View"
    end
  end

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

    expect(page).to have_content("SOURCE Account#1")
    expect(page).to have_content("DESTINATION Account#2")
    expect(page).to have_content("VALUE $100.0")
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
        expect(page).to have_content("Comment#1")
        expect(page).to have_content("admin@example.com")
      end
    end

    it "should link to a new form" do
      click_on "Transfers"
      within "#transfer_#{transfer.id}" do
        click_on "View"
      end

      expect(page).to have_link "New Transfer"
    end

    context "when deleting" do
      context "when is not confirmed" do
        it "should destroy" do
          click_on "Transfer"
          within "#transfer_#{transfer.id}" do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content("Transfer was successfully destroyed")
        end
      end

      context "when is confirmed" do
        before { transfer.update(confirmed: true) }

        it "should not destroy" do
          click_on "Transfer"
          within "#transfer_#{transfer.id}" do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_no_content("Transfer was successfully destroyed")
          expect(page).to have_content("Account#1")
        end
      end
    end
  end
end
