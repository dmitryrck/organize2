require 'rails_helper'

describe 'Transfer', type: :feature do
  before do
    visit '/'
  end

  it 'paginate by month' do
    account1 = Account.create(name: 'Account#1')
    account2 = Account.create(name: 'Account#2')

    Transfer.create source: account1,
      destination: account2,
      value: 100,
      transfered_at: Date.current

    Transfer.create source: account1,
      destination: account2,
      value: 120,
      transfered_at: 1.month.ago

    click_on 'Transfers'

    expect(page).to have_content '$100.00'
    click_on 'Previous'
    expect(page).to have_content '$120.00'
  end

  it 'create' do
    Account.create name: 'Account#1'
    Account.create name: 'Account#2'

    click_on 'Transfers'

    click_on 'New'

    select 'Account#1', from: 'Source'
    select 'Account#2', from: 'Destination'
    expect(page).to have_field 'Transfered at', with: Date.current
    fill_in 'Value', with: '100'

    click_on 'Create'

    expect(page).to have_content 'Transfer was successfully created.'

    expect(page).to have_content 'Source: Account#1'
    expect(page).to have_content 'Destination: Account#2'
    expect(page).to have_content 'Value: $100.00'
  end

  it 'update' do
    transfer = Transfer.create(
      source: Account.create(name: 'Account#1'),
      destination: Account.create(name: 'Account#2'),
      value: 100,
      transfered_at: Date.current
    )

    click_on 'Transfers'

    click_on transfer.id

    click_on 'Edit'

    select 'Account#2', from: 'Source'
    select 'Account#1', from: 'Destination'
    fill_in 'Value', with: '200'

    click_on 'Update'

    expect(page).to have_content 'Transfer was successfully updated.'
    expect(page).to have_content 'Source: Account#2'
    expect(page).to have_content 'Destination: Account#1'
    expect(page).to have_content 'Value: $200.00'
  end

  it 'can confirm', js: true do
    account1 = Account.create(name: 'Account#1', balance: 10, start_balance: 0)
    account2 = Account.create(name: 'Account#2', balance: 0, start_balance: 0)

    transfer = Transfer.create(
      source: account1,
      destination: account2,
      value: 10,
      transfered_at: Date.current
    )

    click_on 'Transfers'

    click_link 'Confirm'
    expect(page).to have_content 'Successfully transfered'

    click_link 'Edit'
    expect(page).to have_disabled_field 'Value'

    expect(account1.reload.balance).to eq 0
    expect(account2.reload.balance).to eq 10
  end

  it 'can unconfirm' do
    account1 = Account.create(name: 'Account#1', balance: 0, start_balance: 0)
    account2 = Account.create(name: 'Account#2', balance: 10, start_balance: 0)

    transfer = Transfer.create(
      source: account1,
      destination: account2,
      value: 10,
      transfered: true,
      transfered_at: Date.current
    )

    click_on 'Transfers'
    click_link 'Unconfirm'
    expect(page).to have_content 'Successfully unconfirmed'

    click_link 'Edit'
    expect(page).not_to have_disabled_field 'Value'

    expect(account1.reload.balance).to eq 10
    expect(account2.reload.balance).to eq 0
  end
end
