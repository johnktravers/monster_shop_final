require 'rails_helper'

RSpec.describe 'As an admin on a users order show page' do
  before :each do
    create_admin
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin
  end

  it 'can see order information' do
    visit "/admin/users/#{@user.id}/orders/#{@order_1.id}"

    within "#order-info" do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_content(@order_1.item_orders.count)
      expect(page).to have_content(@order_1.grandtotal)
    end
  end

  it 'can see information on each item ordered' do
    visit "/admin/users/#{@user.id}/orders/#{@order_1.id}"

    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content("2")
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content("$200.00")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content("$#{@paper.price}")
      expect(page).to have_content("1")
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("$20.00")
    end

    expect(page).to_not have_css("#item-#{@pencil.id}")
  end

  it 'cannot go to an order show page for a nonexistent user or order' do
    visit "/admin/users/#{@user.id}/orders/2546"
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit "/admin/users/2315/orders/1"
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
