require 'rails_helper'

RSpec.describe 'As an admin' do
  before :each do
    create_admin
    login_as_admin
  end

  it 'can see a nav bar with links to all pages' do
    visit '/merchants'

    within('nav') { click_link 'Home' }
    expect(current_path).to eq('/')

    within('nav') { click_link 'Items' }
    expect(current_path).to eq('/items')

    within('nav') { click_link 'Merchants' }
    expect(current_path).to eq('/merchants')

    within('nav') { click_link 'Profile' }
    expect(current_path).to eq('/profile')

    within('nav') { click_link 'Dashboard' }
    expect(current_path).to eq('/admin')

    within('nav') { click_link 'Users' }
    expect(current_path).to eq('/admin/users')

    within('nav') { click_link 'Logout' }
    expect(current_path).to eq('/')
  end

  it 'cannot see links Im not authorized for' do
    visit '/items'

    within('nav') do
      expect(page).to_not have_link 'Login'
      expect(page).to_not have_link 'Register'
      expect(page).to_not have_link 'Cart (0)'
    end
  end

  it 'can see login name' do
    visit '/items'

    within('nav') { expect(page).to have_content('Logged in as Ron Swanson') }
  end

  it 'cannot access certain paths' do
    visit '/merchant'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/cart'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/admin/merchants/1/orders/1'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
