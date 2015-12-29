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

    click_on 'Cards'

    click_on card.id

    click_on 'Edit'

    fill_in 'Name', with: 'Card#2'
    fill_in 'Payment day', with: '1'

    click_on 'Update'

    expect(page).to have_content 'Card was successfully updated.'
    expect(page).to have_content 'Name: Card#2'
    expect(page).to have_content 'Payment day: 1'
  end

  it 'paginate card movements' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    Outgo.create description: 'Outgo#1',
      value: 100,
      paid_at: Date.current,
      chargeable: card

    Outgo.create description: 'Outgo#2',
      value: 100,
      paid_at: 1.month.ago,
      chargeable: card

    click_on 'Card'
    click_on "##{card.id}"

    expect(page).to have_content 'Outgo#1'
    click_on 'Previous'
    expect(page).to have_content 'Outgo#2'
  end

  it 'create a new outgo' do
    card = Card.create name: 'Card#1',
      limit: 100,
      payment_day: 15

    click_on 'Cards'

    click_on card.id

    click_on 'New'

    expect(page).to have_select 'Kind', selected: 'Card'
    expect(page).to have_select 'Card', selected: 'Card#1'
    expect(page).to have_field 'Paid at', with: Date.current.to_s
  end
end
