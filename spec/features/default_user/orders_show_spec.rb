require 'rails_helper'

RSpec.describe 'As a default user on my order show page' do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_default_user
  end

  it 'can see order information' do
    visit "/profile/orders/#{@order_1.id}"

    within '#order-info' do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_content(@order_1.item_orders.count)
      expect(page).to have_content(@order_1.grandtotal)
    end
  end

  it 'can see the shipping address' do
    visit "/profile/orders/#{@order_1.id}"

    within "#address-#{@address_1.id}" do
      expect(page).to have_content('123 Lincoln St')
      expect(page).to have_content('Denver, CO 23840')
      expect(page).to have_content('Current Shipping Address')
      expect(page).to_not have_button('Ship to this Address')
    end
  end

  it 'can change the shipping address if order is pending' do
    visit "/profile/orders/#{@order_1.id}"
    within("#address-#{@address_2.id}") { click_button 'Ship to this Address' }

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    expect(page).to have_content("You have successfully updated your address for Order ##{@order_1.id}!")

    within "#address-#{@address_2.id}" do
      expect(page).to have_content('412 Broadway Blvd')
      expect(page).to have_content('Topeka, KS 34142')
      expect(page).to have_content('Current Shipping Address')
      expect(page).to_not have_button('Ship to this Address')
    end

    within "#address-#{@address_1.id}" do
      expect(page).to have_content('123 Lincoln St')
      expect(page).to have_content('Denver, CO 23840')
      expect(page).to have_button('Ship to this Address')
      expect(page).to_not have_content('Current Shipping Address')
    end
  end

  it 'can see a link to create an address if I have only one address' do
    ItemOrder.where(order_id: @order_2.id).destroy_all
    @order_2.destroy
    @address_2.destroy

    visit "/profile/orders/#{@order_1.id}"

    expect(page).to_not have_content('Ship to this Address')
    expect(page).to have_content('Please create a new address in order to ship to a different address')

    click_link('create a new address')
    expect(current_path).to eq('/profile/addresses/new')
  end

  it 'can see item information only for items in the order' do
    visit "/profile/orders/#{@order_1.id}"

    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content('2')
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content('$200.00')
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content("$#{@paper.price}")
      expect(page).to have_content('1')
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content('$20.00')
    end

    expect(page).to_not have_css("#item-#{@pencil.id}")
  end

  it 'cannot go to an order show page that does not exist' do
    visit "/profile/orders/41436"

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end

  it 'can see what coupon was used on the order if there is one' do
    create_coupons(@mike)
    order_3 = @address_1.orders.create(coupon_id: @coupon_1.id)
    order_3.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3, status: 1)
    order_3.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4, status: 1)
    order_3.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)

    visit "/profile/orders/#{order_3.id}"

    expect(page).to have_content('Halloween Sale')
    expect(page).to have_content('40% Off')
  end

  it 'can see subtotal and grand total differences from coupon' do
    create_coupons(@mike)
    order_3 = @address_1.orders.create(coupon_id: @coupon_1.id)
    order_3.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3, status: 1)
    order_3.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4, status: 1)
    order_3.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)

    visit "/profile/orders/#{order_3.id}"

    within '#order-info' do
      expect(page).to have_content('Full Price: $328.00')
      expect(page).to have_content('Discounted: $316.80')
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content("$20.00\n↓\n$12.00")
    end

    within "#item-#{@pencil.id}" do
      expect(page).to have_content("$8.00\n↓\n$4.80")
    end

    within "#item-#{@tire.id}" do
      expect(page).to_not have_content("$300.00\n↓\n$300.00")
    end
  end
end
