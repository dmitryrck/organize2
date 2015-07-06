require 'rails_helper'

describe 'Income', type: :feature do
  it 'create' do
    visit '/'

    click_on 'Incomes'

    click_on 'New'

    fill_in 'Description', with: 'Income#1'
    fill_in 'Value', with: '101'

    click_on 'Criar'

    expect(page).to have_content 'Income criado com sucesso.'
  end
end
