require 'rails_helper'

RSpec.describe 'As a visitor on the cart show page with items in cart' do
  before(:each) do
    create_merchants_and_items
    add_item_to_cart(@paper)
    add_item_to_cart(@tire)
    add_item_to_cart(@pencil)

    @items_in_cart = [@paper, @tire, @pencil]
  end

  it 'can see a button to increment and decrement the item next to each item' do
    visit '/cart'

    @items_in_cart.each do |item|
      within "#cart-item-#{item.id}" do
        expect(page).to have_link('+')
        expect(page).to have_link('-')
      end
    end
  end

  it 'can increment the quantity of each item' do
    visit '/cart'

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('1')
      click_link '+'
    end

    expect(current_path).to eq('/cart')

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('2')
    end
  end

  it 'can decrement the quantity of each item' do
    visit '/cart'

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('1')
      click_link '+'
      click_link '-'
    end

    expect(current_path).to eq('/cart')

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('1')
    end
  end

  it 'can only increment the quantity of each item up to the inventory amount' do
    visit '/cart'

    within "#cart-item-#{@paper.id}" do
      click_on '+'
      click_on '+'
    end

    expect(current_path).to eq('/cart')

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('3')
      click_on '+'
    end

    expect(current_path).to eq('/cart')
    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('3')
    end
  end

  it 'can delete the item by decrementing to 0' do
    visit '/cart'

    within "#cart-item-#{@paper.id}" do
      click_on '-'
    end

    expect(current_path).to eq('/cart')
    expect(page).to_not have_css("#cart-item-#{@paper.id}")
  end
end
