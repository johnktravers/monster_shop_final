require 'rails_helper'

RSpec.describe 'As a visitor on the merchant show page', type: :feature do
  it 'can see a merchants statistics' do
    create_merchants_and_items
    create_user_with_addresses
    create_orders

    visit "/merchants/#{@mike.id}"

    within '.merchant-stats' do
      expect(page).to have_content('Number of Items: 2')
      expect(page).to have_content('Average Price of Items: $11.00')

      within '.distinct-cities' do
        expect(page).to have_content('Cities that order these items:')
        expect(page).to have_content('Topeka')
        expect(page).to have_content('Denver')
      end
      
    end
  end
end
