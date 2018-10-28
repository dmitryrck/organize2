require "rails_helper"

describe "Outgos" do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  it "should be able to summarize" do
    create(:outgo, date: 1.year.ago, value: 30)
    create(:outgo)
    create(:outgo2, value: 20)

    click_on "Outgos"

    expect(page).to have_content "120"

    fill_in "q_description", with: "Outgo#1"
    click_on "Filter"

    expect(page).to have_content "130"
  end

  it "should be able to create" do
    create(:account)

    click_on "Outgos"
    click_on "New"

    fill_in "Description", with: "Outgo#1"
    expect(page).to have_field "Date", with: Date.current.to_s
    fill_in "Date", with: "2017-12-31"
    fill_in "Value", with: 100
    select "Account#1", from: "outgo[chargeable_id]"

    click_on "Create"

    expect(page).to have_content("Outgo#1")
    expect(page).to have_content("$100.00")
    expect(page).to have_content("$0.0")
    expect(page).to have_content("ACCOUNT/CARD Account#1")
  end

  context "when there is an outgo" do
    let!(:outgo) { create(:outgo) }

    it "should be able to update" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "Edit"
      end

      fill_in "Description", with: "Outgo#2"
      fill_in "Value", with: "12.99"

      click_on "Update"

      expect(page).to have_content("Outgo#2")
      expect(page).to have_content("$12.99")
    end

    it "should be able to comment" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
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
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "Delete"
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).not_to have_content("Outgo#1")
    end

    it "duplicate" do
      click_on "Outgos"
      within "#outgo_#{outgo.id}" do
        click_on "View"
      end

      click_on "Duplicate"

      expect(page).to have_field "Description", with: "Outgo#1"
    end

    context "can't edit some fields" do
      it "if confirmed" do
        outgo.update_column(:confirmed, true)

        click_on "Outgos"
        within "#outgo_#{outgo.id}" do
          click_on "Edit"
        end

        expect(page).to have_field "outgo[chargeable_id]", disabled: true
        expect(page).to have_field "Value", disabled: true
        expect(page).to have_field "Fee", disabled: true
        expect(page).to have_field "Card", disabled: true
      end
    end
  end
end
