require 'rails_helper'

RSpec.describe 'As a visitor on the merchant index page', type: :feature do
  it 'can see a list of merchants in the system' do
    create_merchants_and_items
    visit merchants_path

    expect(page).to have_link("Mike's Print Shop")
    expect(page).to have_link("Meg's Bike Shop")
  end
end
