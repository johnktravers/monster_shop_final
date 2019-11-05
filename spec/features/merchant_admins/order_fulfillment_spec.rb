require 'rails_helper'

RSpec.describe 'As a merchant admin on an order show page' do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    create_merchant_admin
    login_as_merchant_admin

    @order_2.update(status: 1)
    @order_2.item_orders.each { |item_order| item_order.update!(status: 0) }
    @order_2.item_orders.find_by(item_id: @pencil.id).update!(quantity: 104)
  end

  it 'can see customer info and info only for my items' do
    visit '/merchant'
    within("#order-#{@order_2.id}") { click_link("#{@order_2.id}") }

    expect(current_path).to eq("/merchant/orders/#{@order_2.id}")

    within '#customer-info' do
      expect(page).to have_content('Andy Dwyer')
      expect(page).to have_content('412 Broadway Blvd Topeka, KS 34142')
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_link(@paper.name)
      expect(page).to have_content('1')
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content('$20.00')
    end

    within "#item-#{@pencil.id}" do
      expect(page).to have_link(@pencil.name)
      expect(page).to have_content('104')
      expect(page).to have_css("img[src*='#{@pencil.image}']")
      expect(page).to have_content('$2.00')
    end

    expect(page).to_not have_css("#item-#{@tire.id}")
  end

  it 'can fulfill an unfulfilled item and it decreased item inventory' do
    visit "/merchant/orders/#{@order_2.id}"

    within("#item-#{@paper.id}") { click_button('Fulfill Item') }

    expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
    expect(page).to have_content("You have successfully fulfilled Lined Paper for Order ##{@order_2.id}")

    within "#item-#{@paper.id}" do
      expect(page).to have_content('Fulfilled')
      expect(page).to_not have_button('Fulfill Item')
    end

    visit "/items/#{@paper.id}"

    expect(page).to have_content('Inventory: 2')
  end

  it 'cannot fulfill an item if it does not have enough inventory' do
    visit "/merchant/orders/#{@order_2.id}"

    within "#item-#{@pencil.id}" do
      expect(page).to have_content('Unfulfilled')
      expect(page).to have_content('Cannot Fulfill (Not Enough Inventory)')
      expect(page).to_not have_button('Fulfill Item')
    end
  end

  it 'cannot fulfill a cancelled item order' do
    click_link 'Logout'

    login_as_default_user

    click_link 'Your Orders'
    click_link "#{@order_2.id}"
    click_button 'Cancel Order'
    click_link 'Logout'

    login_as_merchant_admin

    visit "/merchant/orders/#{@order_2.id}"

    within "#item-#{@pencil.id}" do
      expect(page).to have_content('Cancelled')
      expect(page).to_not have_content('Fulfilled')
      expect(page).to_not have_content('Unfulfilled')
      expect(page).to_not have_button('Fulfill Item')
    end
  end
end
