require 'rails_helper'

RSpec.describe 'As an admin user on my admin dashboard page', type: :feature do
  before :each do
    create_admin
    create_two_users_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin
  end

  it 'can see all orders sorted by status' do
    within '.order-0' do
      expect(page).to have_content(@order_2.id)
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_2.status.capitalize)
      expect(page).to have_link(@user_2.name)
    end

    within '.order-1' do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_link(@user_1.name)
    end
  end

  it 'can see links to profile of user who placed order' do
    click_link "#{@user_1.name}"

    expect(current_path).to eq("/admin/users/#{@user_1.id}")
  end
end
