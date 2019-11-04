require 'rails_helper'

RSpec.describe 'As a default user on the cart show page' do
  describe 'When I have added items to my cart' do
    before(:each) do
      create_merchants_and_items
      add_item_to_cart(@paper)
      add_item_to_cart(@tire)
      add_item_to_cart(@pencil)

      create_user_with_addresses
      login_as_default_user
    end

    it 'can see a link to checkout' do
      visit '/cart'
      click_link 'Checkout'

      expect(current_path).to eq('/profile/orders/new')
    end
  end

  describe 'When I havent added items to my cart' do
    it 'cannot see a link to checkout' do
      visit '/cart'

      expect(page).to_not have_link('Checkout')
    end
  end
end
