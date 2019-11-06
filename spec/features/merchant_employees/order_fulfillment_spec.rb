require 'rails_helper'

RSpec.describe 'When I visit an order show page as a merchant employee' do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    create_merchant_employees
    login_as_mikes_employee

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
      expect(page).to have_content("412 Broadway Blvd\nTopeka, KS 34142")
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

    login_as_mikes_employee
    visit "/merchant/orders/#{@order_2.id}"

    within "#item-#{@pencil.id}" do
      expect(page).to have_content('Cancelled')
      expect(page).to_not have_content('Fulfilled')
      expect(page).to_not have_content('Unfulfilled')
      expect(page).to_not have_button('Fulfill Item')
    end
  end

  it 'changes order status to packaged if all items are fulfilled' do
    click_link 'Logout'

    order = Order.create!(address_id: @address_1.id)
    order.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 7)
    order.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 50)

    login_as_mikes_employee

    visit "/merchant/orders/#{order.id}"
    within("#item-#{@pencil.id}") { click_button('Fulfill Item') }
    click_link 'Logout'

    login_as_megs_employee

    visit "/merchant/orders/#{order.id}"
    within("#item-#{@tire.id}") { click_button('Fulfill Item') }
    click_link 'Logout'

    login_as_default_user

    visit '/profile/orders'
    within("#order-#{order.id}") { expect(page).to have_content('Packaged') }
  end

  it 'can see what coupon was used on the order if there is one' do
    create_coupons(@mike)
    order_3 = @address_1.orders.create(coupon_id: @coupon_1.id)
    order_3.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3, status: 1)
    order_3.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4, status: 1)
    order_3.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)

    visit "/merchant/orders/#{order_3.id}"

    expect(page).to have_content('Halloween Sale')
    expect(page).to have_content('40% Off')
  end
end
