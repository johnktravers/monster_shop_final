require 'rails_helper'

RSpec.describe 'As a visitor on an item show page' do
  before :each do
    create_merchants_and_items
  end

  it 'can see a link to add this item to my cart' do
    visit "/items/#{@paper.id}"

    expect(page).to have_button("Add Item to Cart")
  end

  it 'can add this item to my cart' do
    visit "/items/#{@paper.id}"
    click_on 'Add Item to Cart'

    expect(page).to have_content("#{@paper.name} was successfully added to your cart")
    expect(current_path).to eq(items_path)

    within 'nav' do
      expect(page).to have_content('Cart (1)')
    end

    visit "/items/#{@pencil.id}"
    click_on 'Add Item to Cart'

    within 'nav' do
      expect(page).to have_content('Cart (2)')
    end
  end
end
