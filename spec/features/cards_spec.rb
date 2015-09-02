require 'rails_helper'

describe 'Card', type: :feature do
  before do
    visit '/'
  end

  it 'create' do
    click_on 'Cards'

    click_on 'New'

    fill_in 'Name', with: 'Card#1'
    fill_in 'Limit', with: '1000'
    fill_in 'Payment day', with: '15'

    click_on 'Create'

    expect(page).to have_content 'Card was successfully created.'

    expect(page).to have_content 'Name: Card#1'
    expect(page).to have_content 'Limit: $1,000.00'
    expect(page).to have_content 'Payment day: 15'
  end

  it 'update' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    visit edit_card_path(card)

    fill_in 'Name', with: 'Card#2'
    fill_in 'Payment day', with: '1'

    click_on 'Update'

    expect(page).to have_content 'Card was successfully updated.'
    expect(page).to have_content 'Name: Card#2'
    expect(page).to have_content 'Payment day: 1'
  end
end
