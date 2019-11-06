require 'rails_helper'

RSpec.describe 'As a default user on my orders index page', type: :feature do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_default_user
  end

  it 'can see order information' do
    visit '/profile/orders'

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

  it 'can click a link to go to the order show page' do
    visit '/profile/orders'

    click_link("#{@order_1.id}")

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")
  end

  it 'shows the discounted grand total if a coupon code was used' do
    create_coupons(@mike)
    order_3 = @address_1.orders.create(coupon_id: @coupon_1.id)
    order_3.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3, status: 1)
    order_3.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4, status: 1)
    order_3.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)

    visit '/profile/orders'

    within "#order-#{order_3.id}" do
      expect(page).to have_content('$316.80')
      expect(page).to_not have_content('$328.00')
    end
  end
end
