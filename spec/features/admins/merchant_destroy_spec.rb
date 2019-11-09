require 'rails_helper'

RSpec.describe 'As an admin on a merchant show page' do
  before :each do
    create_merchants_and_items
    create_admin
    login_as_admin
  end

  it 'can delete a merchant that does not have orders' do
    visit "/admin/merchants/#{@meg.id}"
    click_button 'Delete Merchant'

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("You have successfully deleted #{@meg.name}")

    visit merchants_path
    expect(page).to_not have_content("Meg's Bike Shop")
  end

  it 'deleting a merchant with items deletes its items' do
    visit "/admin/merchants/#{@mike.id}"
    click_button 'Delete Merchant'

    visit '/items'

    expect(page).to_not have_css("#item-#{@paper.id}")
    expect(page).to_not have_css("#item-#{@pencil.id}")
  end

  it 'cannot delete a merchant that has orders' do
    create_user_with_addresses
    create_orders

    visit "/admin/merchants/#{@meg.id}"
    expect(page).to_not have_button('Delete Merchant')
  end
end
