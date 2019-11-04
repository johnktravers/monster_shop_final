require 'rails_helper'

RSpec.describe 'Admin order shipment' do
  before :each do
    create_admin
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin
  end

  it 'can see packaged orders that are ready to ship' do
    visit '/admin'

    within "#order-#{@order_1.id}" do
      expect(page).to have_content('Not Ready for Shipment')
      expect(page).to_not have_button('Ship Order')
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_content('Ready for Shipment')
      expect(page).to have_button('Ship Order')
    end
  end

  it 'can click a button to ship packaged orders' do
    visit '/admin'

    within("#order-#{@order_2.id}") { click_button('Ship Order') }

    expect(current_path).to eq('/admin')
    within("#order-#{@order_2.id}") { expect(page).to have_content('Shipped') }
  end

  it 'a user cannot cancel an order after it has been shipped' do
    visit '/admin'
    within("#order-#{@order_2.id}") { click_button('Ship Order') }
    click_link 'Logout'

    login_as_default_user

    visit "/profile/orders/#{@order_2.id}"

    expect(page).to_not have_button 'Cancel Order'
  end

end
