require 'rails_helper'

RSpec.describe 'As a default user creating a new order' do
  before(:each) do
    create_user_with_addresses
    create_merchants_and_items
    login_as_default_user

    add_item_to_cart(@tire)
    add_item_to_cart(@paper)
    add_item_to_cart(@pencil)
    add_item_to_cart(@pencil)
    add_item_to_cart(@tire)

    visit '/cart'
    click_link 'Checkout'
  end

  it 'can see the details of my cart' do
    within "#order-item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@meg.name)
      expect(page).to have_content('$100.00')
      expect(page).to have_content('2')
      expect(page).to have_content('$200.00')
    end

    within "#order-item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@mike.name)
      expect(page).to have_content('$20.00')
      expect(page).to have_content('1')
      expect(page).to have_content('$20.00')
    end

    within "#order-item-#{@pencil.id}" do
      expect(page).to have_content(@pencil.name)
      expect(page).to have_content(@mike.name)
      expect(page).to have_content('$2.00')
      expect(page).to have_content('2')
      expect(page).to have_content('$4.00')
    end

    expect(page).to have_content('Grand Total: $224.00')
  end

  it 'can see the addresses I can choose for shipping' do
    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname)
      expect(page).to have_content(@address_1.address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zip)
      expect(page).to have_button('Ship to this Address')
    end

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname)
      expect(page).to have_content(@address_2.address)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zip)
      expect(page).to have_button('Ship to this Address')
    end
  end

  it 'can select coupon codes and see them applied to a discounted total' do
    create_coupons(@mike)
    visit '/cart'

    within("#coupon-#{@coupon_1.id}") { click_button 'Apply Coupon' }

    within "#cart-item-#{@paper.id}" do
      expect(page).to have_content('Full Price: $20.00')
      expect(page).to have_content('Discounted: $12.00')
    end

    within "#cart-item-#{@pencil.id}" do
      expect(page).to have_content('Full Price: $4.00')
      expect(page).to have_content('Discounted: $2.40')
    end

    expect(page).to have_content('You have applied the Halloween Sale coupon to your cart!')
    expect(page).to have_content('Discounted Total: $214.40')
  end

  it 'can create an order with coupon code discount' do
    create_coupons(@mike)
    visit '/cart'

    within("#coupon-#{@coupon_1.id}") { click_button 'Apply Coupon' }
    click_link 'Checkout'

    within "#order-item-#{@paper.id}" do
      expect(page).to have_content('Full Price: $20.00')
      expect(page).to have_content('Discounted: $12.00')
    end

    within "#order-item-#{@pencil.id}" do
      expect(page).to have_content('Full Price: $4.00')
      expect(page).to have_content('Discounted: $2.40')
    end

    expect(page).to have_content('Discounted Total: $214.40')
  end

  it 'cannot use the same coupon on two different orders' do
    create_coupons(@mike)
    visit '/cart'

    within("#coupon-#{@coupon_1.id}") { click_button 'Apply Coupon' }
    click_link 'Checkout'
    within("#address-#{@address_2.id}") { click_button 'Ship to this Address' }

    add_item_to_cart(@tire)
    add_item_to_cart(@paper)
    visit '/cart'

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to_not have_button 'Apply Coupon'
    end
  end

  it 'can create an order by selecting an address' do
    within "#address-#{@address_2.id}" do
      click_button 'Ship to this Address'
    end

    expect(current_path).to eq('/profile/orders')
    expect(page).to have_content('Your order has been successfully created!')

    order = Order.last
    visit "/profile/orders/#{order.id}"

    expect(page).to have_content('412 Broadway Blvd')
    expect(page).to have_content('Topeka, KS 34142')
  end

  it 'empties the cart after an order is made' do
    within "#address-#{@address_2.id}" do
      click_button 'Ship to this Address'
    end

    within 'nav' do
      expect(page).to have_link('Cart (0)')
    end
  end

  it 'must create an address to place an order' do
    Address.destroy_all
    visit '/profile/orders/new'

    expect(page).to have_content('You must create an address to place an order')

    click_link('New Address')

    expect(current_path).to eq('/profile/addresses/new')
  end

  # it 'cannot create an order without items', js: true do
  #   page.evaluate_script('window.history.back()')
  #
  #   click_on 'Checkout'
  #
  #   expect(current_path).to eq(items_path)
  #   expect(page).to have_content("Please add something to your cart to place an order")
  # end
end
