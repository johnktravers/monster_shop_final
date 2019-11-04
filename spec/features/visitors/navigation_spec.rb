require 'rails_helper'

RSpec.describe 'As a visitor' do
  it 'can see a nav bar with links to all pages' do
    visit '/merchants'

    within('nav') { click_link 'Home' }
    expect(current_path).to eq('/')

    within('nav') { click_link 'Items' }
    expect(current_path).to eq('/items')

    within('nav') { click_link 'Merchants' }
    expect(current_path).to eq('/merchants')

    within('nav') { click_link 'Login' }
    expect(current_path).to eq('/login')

    within('nav') { click_link 'Register' }
    expect(current_path).to eq('/register')
  end

  it 'cannot see links Im not authorized for' do
    visit '/items'

    within('nav') do
      expect(page).to_not have_link 'Logout'
      expect(page).to_not have_link 'Profile'
      expect(page).to_not have_link 'Dashboard'
      expect(page).to_not have_content 'Logged in as'
    end
  end

  it 'can see a cart indicator on all pages' do
    visit '/merchants'
    within('nav') { expect(page).to have_content('Cart (0)') }

    visit '/items'
    within('nav') { expect(page).to have_content('Cart (0)') }
  end

  it "cannot access certain paths" do
    visit '/merchant'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/admin'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/profile'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/profile/edit'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
