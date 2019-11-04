require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  it 'cannot access certain paths' do
    create_merchants_and_items
    create_merchant_employees
    login_as_megs_employee

    expect(page).to have_content('Logged in as April Ludgate')

    visit '/admin'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/merchant/orders/1'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
