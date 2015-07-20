require 'rails_helper'

describe 'Outgo', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    Account.create name: 'Account#1', start_balance: 10
    click_on 'Outgos'

    click_on 'New'

    fill_in 'Description', with: 'Outgo#1'
    fill_in 'Category', with: 'Food'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
    fill_in 'Paid at', with: '2015-05-31'
    fill_in 'Value', with: '101'
    select 'Account#1', from: 'Account'

    click_on 'Create'

    expect(page).to have_content 'Outgo was successfully created.'

    expect(page).to have_content 'Description: Outgo#1'
    expect(page).to have_content 'Account: Account#1'
    expect(page).to have_content 'Category: Food'
    expect(page).to have_content 'Paid at: 2015-05-31'
  end

  it 'update' do
    outgo = Outgo.create description: 'Income#1',
      value: 100,
      paid_at: Date.current,
      account: Account.create(name: 'Account#1')

    visit edit_outgo_path(outgo)

    fill_in 'Description', with: 'Outgo#2'
    fill_in 'Paid at', with: '2014-12-31'

    click_on 'Update'

    expect(page).to have_content 'Outgo was successfully updated.'
    expect(page).to have_content 'Description: Outgo#2'
    expect(page).to have_content 'Paid at: 2014-12-31'
  end
end
