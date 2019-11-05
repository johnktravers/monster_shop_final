require 'rails_helper'

RSpec.describe 'As a visitor on the merchant show page', type: :feature do
  before :each do
    create_merchants_and_items
  end

  it 'can see a merchants name, address, city, state, zip' do
    visit "/merchants/#{@meg.id}"

    expect(page).to have_content("Meg's Bike Shop")
    expect(page).to have_content('123 Bike Rd Denver, CO 80203')
  end

  it 'can see a link to visit the merchant items' do
    visit "/merchants/#{@meg.id}"

    expect(page).to have_link("All #{@meg.name} Items")

    click_on "All #{@meg.name} Items"

    expect(current_path).to eq("/merchants/#{@meg.id}/items")
  end
end
