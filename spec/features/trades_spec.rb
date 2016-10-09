require 'rails_helper'

describe 'Trade', type: :feature do
  before { visit '/' }

  it 'paginate by month' do
    account1 = create(:account)
    account2 = create(:account2)

    create(:trade)
    create(:last_month_trade)

    click_on 'Trades'

    expect(page).to have_content('$10.00') & \
      have_content('$20.00')

    click_on 'Previous'
    expect(page).to have_content('$120.00') & \
      have_content('$240.00')
  end

  it 'create' do
    create(:account)
    create(:account2)

    click_on 'Trades'

    click_on 'New'

    select 'Account#1', from: 'Source'
    select 'Account#2', from: 'Destination'
    expect(page).to have_field 'Trade at', with: Date.current
    fill_in 'Value in', with: '100'
    fill_in 'Value out', with: '200'
    fill_in 'Fee', with: '1'

    click_on 'Create'

    expect(page).to have_content 'Trade was successfully created.'

    expect(page).to have_content 'Source: Account#1'
    expect(page).to have_content 'Destination: Account#2'
    expect(page).to have_content 'Value in: $100.0'
    expect(page).to have_content 'Value out: $200.0'
    expect(page).to have_content 'Fee: $1.0'
  end

  it 'update' do
    trade = create(:trade)

    click_on 'Trades'

    click_on trade.id

    click_on 'Edit'

    select 'Account#2', from: 'Source'
    select 'Account#1', from: 'Destination'
    fill_in 'Value in', with: '50'
    fill_in 'Value out', with: '100'
    fill_in 'Fee', with: '10'

    click_on 'Update'

    expect(page).to have_content 'Trade was successfully updated.'
    expect(page).to have_content 'Source: Account#2'
    expect(page).to have_content 'Destination: Account#1'
    expect(page).to have_content 'Value in: $50.0'
    expect(page).to have_content 'Value out: $100.0'
    expect(page).to have_content 'Fee: $10.0'
  end

  context 'can confirm' do
    let(:source) { create(:account, balance: 20) }
    let(:destination) { trade.destination }
    let!(:trade) { create(:trade, source: source) }

    it 'from index', js: true do
      click_on 'Trades'

      click_link 'Confirm'
      expect(page).to have_content 'Trade was successfully confirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'from show', js: true do
      click_on 'Trade'
      click_on trade.id

      click_link 'Confirm'
      expect(page).to have_content 'Trade was successfully confirmed'

      expect(page).to have_content 'Source: Account#1'
      expect(page).to have_content 'Value in: $10.00'
    end

    it 'trade funds' do
      visit confirm_trade_path(trade)

      expect(source.reload.balance).to eq 0
      expect(destination.reload.balance).to eq 9
    end

    it 'should disable value field' do
      visit confirm_trade_path(trade)

      click_link 'Edit'
      expect(page).to have_disabled_field 'Value in'
      expect(page).to have_disabled_field 'Value out'
      expect(page).to have_disabled_field 'Fee'
    end
  end

  context 'can unconfirm' do
    let(:source) { trade.source }
    let(:destination) { create(:account2, balance: 10) }
    let!(:trade) { create(:trade, :confirmed, destination: destination) }

    it 'from index' do
      click_on 'Trades'
      click_link 'Unconfirm'

      expect(page).to have_content 'Trade was successfully unconfirmed'
      expect(page).to have_link 'Previous Month'
    end

    it 'from show' do
      click_on 'Trades'
      click_on trade.id
      click_link 'Unconfirm'
      expect(page).to have_content 'Trade was successfully unconfirmed'
      expect(page).to have_content 'Source: Account#1'
    end

    it 'should not disable value field', js: true do
      visit unconfirm_trade_path(trade)

      click_link 'Edit'
      page.driver.render '/tmp/page.png', :full => true
      expect(page).not_to have_disabled_field 'Value in'
      expect(page).not_to have_disabled_field 'Value out'
      expect(page).not_to have_disabled_field 'Fee'
    end

    it 'trade the refunds back' do
      visit unconfirm_trade_path(trade)

      expect(source.reload.balance).to eq 20
      expect(destination.reload.balance).to eq 1
    end
  end
end
