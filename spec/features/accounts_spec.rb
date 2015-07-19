require 'rails_helper'

describe 'Account', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Accounts'

    click_on 'New'

    fill_in 'Name', with: 'Account#1'
    expect(page).to have_field 'Start balance', with: '0.0'
    fill_in 'Start balance', with: '10'
    expect(page).not_to have_field 'Current balance'

    click_on 'Create'

    expect(page).to have_content 'Account was successfully created.'

    expect(page).to have_content 'Name: Account#1'
    expect(page).to have_content 'Start balance: 10'
    expect(page).to have_content 'Current balance: 10'

    expect(Account.last.current_balance).to eq 10.0
  end

  it 'update' do
    account = Account.create name: 'Account#1', start_balance: 10

    visit edit_account_path(account)

    fill_in 'Name', with: 'Account#2'
    expect(page).not_to have_field 'Start balance'

    click_on 'Update'

    expect(page).to have_content 'Account was successfully updated.'
    expect(page).to have_content 'Name: Account#2'
    expect(page).to have_content 'Start balance: 10'
  end
end
