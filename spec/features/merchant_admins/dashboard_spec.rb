require 'rails_helper'

RSpec.describe 'As a merchant admin on my merchant dashboard page' do
  before :each do
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    create_merchant_admin
    login_as_merchant_admin

    @order_2.update(status: 1)
    @order_2.item_orders.each { |item_order| item_order.update!(status: 0) }
  end

  it 'can see the name and address of the merchant I work for' do
    visit '/merchant'

    within '#merchant-info' do
      expect(page).to have_link(@mike.name)
      expect(page).to have_content('123 Paper Rd Denver, CO 80203')
    end

    click_link @mike.name

    expect(current_path).to eq("/merchants/#{@mike.id}")
  end

  it 'can see a list of pending orders' do
    visit '/merchant'

    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(1) }
      expect(page).to have_content('$20.00')
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(5) }
      expect(page).to have_content('$28.00')
    end
  end

  it 'can see a link to my merchants items' do
    within('#merchant-info') { click_link 'My Items' }

    expect(current_path).to eq('/merchant/items')
  end

  it 'sees no pending orders if there are none' do
    ItemOrder.destroy_all
    Order.destroy_all
    visit '/merchant'

    expect(page).to have_content('No Pending Orders')
  end

end
