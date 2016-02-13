require 'rails_helper'

describe 'Account', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Accounts'

    click_on 'New'

    expect(page).not_to have_field 'Active'
    fill_in 'Name', with: 'Account#1'
    expect(page).to have_field 'Start balance', with: '0.0'
    fill_in 'Start balance', with: '10'
    expect(page).not_to have_field 'Balance'

    click_on 'Create'

    expect(page).to have_content 'Account was successfully created.'

    expect(page).to have_content 'Name: Account#1'
    expect(page).to have_content 'Start balance: $10.00'
    expect(page).to have_content 'Balance: $10.00'

    expect(Account.last.balance).to eq 10.0
  end

  it 'update' do
    account = Account.create name: 'Account#1', start_balance: 10

    click_on 'Accounts'

    click_on account.id

    click_on 'Edit'

    uncheck 'Active'
    fill_in 'Name', with: 'Account#2'
    expect(page).not_to have_field 'Start balance'

    click_on 'Update'

    expect(page).to have_content 'Account was successfully updated.'
    expect(page).to have_content 'Name: Account#2'
    expect(page).to have_content 'Start balance: $10.00'
    expect(page).to have_content 'Active: No'
  end

  it 'should summary at home page' do
    Account.create name: 'Account#1', balance: 12
    Account.create name: 'Account#2', balance: 34

    click_on 'Accounts'

    expect(page).to have_content '$46'
  end
end
