require 'rails_helper'

RSpec.describe 'As a visitor with items in my cart' do
  before(:each) do
    create_merchants_and_items
    add_item_to_cart(@paper)
    add_item_to_cart(@tire)
    add_item_to_cart(@pencil)

    @items_in_cart = [@paper, @tire, @pencil]
  end

  it 'can see a button to delete the item next to each item' do
    visit '/cart'

    @items_in_cart.each do |item|
      within "#cart-item-#{item.id}" do
        expect(page).to have_link('Remove')
      end
    end
  end

  it 'can delete individual items from my cart' do
    visit '/cart'

    within "#cart-item-#{@tire.id}" do
      click_on 'Remove'
    end

    expect(current_path).to eq('/cart')
    expect(page).to_not have_css("#cart-item-#{@tire.id}")
    expect(page).to have_css("#cart-item-#{@pencil.id}")
    expect(page).to have_css("#cart-item-#{@paper.id}")
  end
end
