require 'rails_helper'

RSpec.describe 'As an admin on a users profile page', type: :feature do
  before :each do
    create_admin
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin
  end

  it 'can see all user info but no edit link' do
    visit "/admin/users/#{@user.id}"

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
    end

    expect(page).to_not have_link('Edit Your Info')
    expect(page).to_not have_link('Change Your Password')

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname)
      expect(page).to have_content(@address_1.address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zip)
    end

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname)
      expect(page).to have_content(@address_2.address)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zip)
    end
  end

  it 'cannot access a user show page for a nonexistent user' do
    visit '/admin/users/13251'

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end

  it 'can click a link to visit the user orders index' do
    visit "/admin/users/#{@user.id}"
    click_link('Your Orders')

    expect(current_path).to eq("/admin/users/#{@user.id}/orders")
  end
end
