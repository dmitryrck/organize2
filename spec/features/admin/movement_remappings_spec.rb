require "rails_helper"

describe "Movement Remappings", type: :system do
  before { sign_in(user) }

  let(:user) { create(:admin_user) }

  context "index" do
    before do
      create(:movement_remapping, field_to_watch: MovementField::DESCRIPTION, field_to_change: MovementField::DESCRIPTION, active: true)
      create(:movement_remapping, field_to_watch: MovementField::CATEGORY, field_to_change: MovementField::CATEGORY, active: false)

      click_on "Movement Remappings"
    end

    it "filters by active" do
      click_on "Active"
      expect(page).to have_content "description"
    end

    it "filters by inactive" do
      click_on "Inactive"
      expect(page).to have_content "category"
    end
  end

  it "creates" do
    click_on "Movement Remappings"

    click_on "New"

    fill_in "Order", with: "38"
    select "Income", from: "Kind*"
    select "category", from: "Field to watch"
    select "equals", from: "Kind of match"
    fill_in "Text to match", with: "market"
    select "prepend", from: "Kind of change"
    select "paid_to", from: "Field to change"
    fill_in "Text to change", with: "supermarket"

    click_on "Create"

    expect(page).to have_content "ORDER 38"
    expect(page).to have_content "KIND Income"
    expect(page).to have_content "FIELD TO WATCH category"
    expect(page).to have_content "KIND OF MATCH equals"
    expect(page).to have_content "TEXT TO MATCH market"
    expect(page).to have_content "KIND OF CHANGE prepend"
    expect(page).to have_content "FIELD TO CHANGE paid_to"
    expect(page).to have_content "TEXT TO CHANGE supermarket"
  end

  context "when there is a movement remapping" do
    before { create(:movement_remapping, kind_of_change: KindOfChange::PREPEND) }

    it "updates" do
      click_on "Movement Remappings"
      click_on "Edit"

      fill_in "Order", with: "300"

      click_on "Update"

      expect(page).to have_content "ORDER 300"
    end

    it "comments" do
      click_on "Movement Remappings"
      click_on "View"

      fill_in "active_admin_comment[body]", with: "Comment mapping"
      click_on "Add"

      within ".comments" do
        expect(page).to have_content "Comment mapping"
        expect(page).to have_content "admin@example.com"
      end
    end

    it "destroys" do
      click_on "Movement Remappings"
      click_on "Delete"

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content "Movement remapping was successfully destroyed"
      expect(page).to have_content "There are no Movement Remappings yet"
    end
  end
end
