require 'rails_helper'

RSpec.describe 'As a default user on my order show page' do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_default_user
  end

  it 'can cancel a pending order' do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    expect(current_path).to eq(profile_path)

    order = Order.first

    expect(order.status).to eq('cancelled')
    expect(order.item_orders.first.status).to eq('cancelled')
    expect(order.item_orders.last.status).to eq('cancelled')

    expect(page).to have_content('Your order is now cancelled')

    visit '/profile/orders'

    within "#order-#{@order_1.id}" do
      expect(page).to have_content('Cancelled')
    end
  end

  it 'returns item quantity to merchant if item order is fulfilled' do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    visit '/items'

    within "#item-#{@tire.id}" do
      expect(page).to have_content('Inventory: 14')
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content('Inventory: 3')
    end
  end

  it 'can see cancelled order status and no cancel button if order is cancelled' do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    visit "/profile/orders/#{@order_1.id}"

    within '.cart-table' do
      expect(page).to have_content('Cancelled')
    end

    expect(page).to_not have_button('Cancel Order')
  end
end
