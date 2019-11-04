require 'rails_helper'

RSpec.describe 'As a visitor on the cart show page' do
  describe 'When I have added items to my cart' do
    before(:each) do
      create_merchants_and_items
      add_item_to_cart(@paper)
      add_item_to_cart(@tire)
      add_item_to_cart(@pencil)

      @items_in_cart = [@paper, @tire, @pencil]
    end

    it 'can empty my cart by clicking a link' do
      visit '/cart'
      click_on 'Empty Cart'

      expect(current_path).to eq('/cart')
      expect(page).to_not have_css('.cart-items')
      expect(page).to have_content('Cart is currently empty')
    end

    it 'can see all items Ive added to my cart' do
      visit '/cart'

      @items_in_cart.each do |item|
        within "#cart-item-#{item.id}" do
          expect(page).to have_link(item.name)
          expect(page).to have_css("img[src*='#{item.image}']")
          expect(page).to have_link("#{item.merchant.name}")
          expect(page).to have_content("$#{item.price}")
          expect(page).to have_content('1')
          expect(page).to have_content("$#{item.price}")
        end
      end
      expect(page).to have_content('Total: $122')

      visit "/items/#{@pencil.id}"
      click_on 'Add Item to Cart'

      visit '/cart'

      within "#cart-item-#{@pencil.id}" do
        expect(page).to have_content('2')
        expect(page).to have_content('$4')
      end

      expect(page).to have_content('Total: $124')
    end

    it 'shows register and login messages and links if user is not logged in and doesn\'t show checkout link' do
      visit '/cart'

      expect(page).to_not have_link('Checkout')

      within '#cart-logged-out-warning' do
        expect(page).to have_link('login')
        expect(page).to have_link('register')
      end

      expect(page).to have_content('You must register and login in order to complete checkout process.')
    end
  end

  describe 'When I havent added anything to my cart' do
    it 'can see a message saying my cart is empty' do
      visit '/cart'

      expect(page).to_not have_css('.cart-items')
      expect(page).to have_content('Cart is currently empty')
    end

    it 'cannot see the link to empty my cart' do
      visit '/cart'

      expect(page).to_not have_link('Empty Cart')
    end
  end
end
