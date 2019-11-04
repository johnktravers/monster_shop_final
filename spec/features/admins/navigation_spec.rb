require 'rails_helper'

RSpec.describe 'As an admin' do
  it 'cannot access certain paths' do
    create_admin
    login_as_admin

    expect(page).to have_content('Logged in as Ron Swanson')

    visit '/merchant'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/cart'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/admin/merchants/1/orders/1'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
