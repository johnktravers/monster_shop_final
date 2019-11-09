require 'rails_helper'

RSpec.describe 'Merchant admin logout' do
  before :each do
    create_merchants_and_items
    create_merchant_admin
    login_as_merchant_admin
  end

  it 'can log out by going to logout path' do
    visit logout_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Leslie Knope, you have logged out!')

    within 'nav' do
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
      expect(page).to_not have_link('Logout')
    end
  end

  it 'can log out by clicking logout button in navbar' do
    within('nav') { click_link('Logout') }

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Leslie Knope, you have logged out!')

    within 'nav' do
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
      expect(page).to_not have_link('Logout')
    end
  end

  it 'empties the cart after logging out' do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: '80203')
    paper = mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 25)

    visit "/items/#{paper.id}"
    click_button 'Add Item to Cart'

    within('nav') { expect(page).to have_link('Cart (1)') }

    visit logout_path

    within('nav') { expect(page).to have_link('Cart (0)') }
  end
end
