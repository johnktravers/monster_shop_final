require 'rails_helper'

RSpec.describe "As a merchant admin" do
  before :each do
    create_merchants_and_items
    create_merchant_admin
    login_as_merchant_admin
  end

  it 'can see a nav bar with links to all pages' do
    visit merchants_path

    within('nav') { click_link 'Home' }
    expect(current_path).to eq(root_path)

    within('nav') { click_link 'Items' }
    expect(current_path).to eq(items_path)

    within('nav') { click_link 'Merchants' }
    expect(current_path).to eq(merchants_path)

    within('nav') { click_link 'Profile' }
    expect(current_path).to eq(profile_path)

    within('nav') { click_link 'Dashboard' }
    expect(current_path).to eq(merchant_root_path)

    within('nav') { click_link 'Logout' }
    expect(current_path).to eq(root_path)
  end

  it 'cannot see links Im not authorized for' do
    visit '/items'

    within('nav') do
      expect(page).to_not have_link 'Login'
      expect(page).to_not have_link 'Register'
    end
  end

  it 'can see a cart indicator on all pages' do
    visit merchants_path
    within('nav') { expect(page).to have_content('Cart (0)') }

    visit '/items'
    within('nav') { expect(page).to have_content('Cart (0)') }
  end

  it 'can see display login name' do
    visit '/items'

    within('nav') { expect(page).to have_content('Logged in as Leslie Knope') }
  end

  it 'cannot access certain paths' do
    visit admin_root_path
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit '/merchant/orders/1'
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
