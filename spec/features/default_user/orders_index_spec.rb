require 'rails_helper'

RSpec.describe 'As a default user on my orders index page', type: :feature do
  before :each do
    create_user_with_orders
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
end
