require 'rails_helper'

RSpec.describe 'As a default user' do
  it 'cannot access certain paths' do
    create_user_with_addresses
    login_as_default_user

    expect(page).to have_content("Logged in as Andy Dwyer")

    visit '/merchant'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/admin'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
