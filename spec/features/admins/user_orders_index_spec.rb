require 'rails_helper'

RSpec.describe 'As an admin on a users orders index page', type: :feature do
  before :each do
    create_admin
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin
  end

  it 'can see order information' do
    visit "/admin/users/#{@user.id}/orders"

    expect(page).to have_content('Andy Dwyer\'s Orders')

    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_content(@order_1.item_orders.count)
      expect(page).to have_content(@order_1.grandtotal)
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_2.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_2.status.capitalize)
      expect(page).to have_content(@order_2.item_orders.count)
      expect(page).to have_content(@order_2.grandtotal)
    end
  end

  it 'can click a link to go to that users order show page' do
    visit "/admin/users/#{@user.id}/orders"

    within("#order-#{@order_1.id}") { click_link("#{@order_1.id}") }

    expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order_1.id}")
  end

  it 'cannot go to an orders index page for a nonexistent user' do
    visit '/admin/users/2351/orders'

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
