require 'rails_helper'

RSpec.describe 'Admin User Show Page', type: :feature do
  before :each do
    @user = User.create!(name: "Andy Dwyer", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "user@gmail.com", password: "password", password_confirmation: "password")
    @user.orders.create!
    @admin = User.create!(name: "Ron Swanson", address: "789 Washington Blvd", city: "New Orleans", state: "LA", zip: 70010, email: "admin@gmail.com", password: "password", password_confirmation: "password", role: 3)

    visit '/login'

    fill_in :email, with: 'admin@gmail.com'
    fill_in :password, with: 'password'

    click_button 'Login'
  end

  it 'shows all user info but no edit link' do
    visit "/admin/users/#{@user.id}"

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to have_content(@user.email)
    end

    expect(page).to_not have_link('Edit Your Info')
    expect(page).to_not have_link('Change Your Password')
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
