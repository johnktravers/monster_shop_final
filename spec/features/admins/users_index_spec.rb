require 'rails_helper'

RSpec.describe 'Admin Users Index Page', type: :feature do
  it 'can show all users' do
    user_1 = User.create!(name: "Andy Dwyer", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password", password_confirmation: "password")
    user_2 = User.create!(name: "April Ludgate", address: "456 Jefferson Ave", city: "Orlando", state: "FL", zip: 32810, email: "test@hotmail.com", password: "password", password_confirmation: "password")
    user_3 = User.create!(name: "Tom Haverford", address: "1011 Adams Circle", city: "Portland", state: "OR", zip: 89325, email: "test@outlook.com", password: "password", password_confirmation: "password")
    admin = User.create!(name: "Ron Swanson", address: "789 Washington Blvd", city: "New Orleans", state: "LA", zip: 70010, email: "test@aol.com", password: "password", password_confirmation: "password", role: 3)

    visit '/login'

    fill_in :email, with: 'test@aol.com'
    fill_in :password, with: 'password'

    click_button 'Login'

    visit '/'

    click_link 'Users'

    expect(current_path).to eq('/admin/users')

    within "#user-#{user_1.id}" do
      expect(page).to have_link(user_1.name)
      expect(page).to have_content(user_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Default')
    end

    within "#user-#{user_2.id}" do
      expect(page).to have_link(user_2.name)
      expect(page).to have_content(user_2.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Default')
    end

    within "#user-#{user_3.id}" do
      expect(page).to have_link(user_3.name)
      expect(page).to have_content(user_3.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Default')
    end
  end

  it 'has user names that link to admin user show page' do
    user = User.create!(name: "Andy Dwyer", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password", password_confirmation: "password")
    admin = User.create!(name: "Ron Swanson", address: "789 Washington Blvd", city: "New Orleans", state: "LA", zip: 70010, email: "test@aol.com", password: "password", password_confirmation: "password", role: 3)

    visit '/login'

    fill_in :email, with: 'test@aol.com'
    fill_in :password, with: 'password'

    click_button 'Login'

    visit '/admin/users'

    click_link user.name

    expect(current_path).to eq("/admin/users/#{user.id}")
  end

  it 'cannot be accessed by other user types' do
    user = User.create!(name: "Andy Dwyer", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password", password_confirmation: "password")
    florist = Merchant.create(name: 'Florist Gump', address: '1523 N Main Street', city: 'Plaintree', state: 'MN', zip: 49155)
    merchant_employee = florist.users.create(name: "Lael Whipple", address: "7392 Oklahoma Ave", city: "Nashville", state: "TN", zip: 37966, email: "whip_whipple@yahoo.com", password: "password12", password_confirmation: "password12", role: 1)
    merchant_admin = florist.users.create(name: "Dudley Laughlin", address: "2348 Willow Dr", city: "Big Sky", state: "MT", zip: 59716, email: "bigskyguy@aol.com", password: "password123", password_confirmation: "password123", role: 2)

    visit '/login'
    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password'
    click_button 'Login'
    visit '/'
    expect(page).to_not have_link('Users')
    visit '/admin/users'
    expect(page).to have_content('The page you were looking for doesn\'t exist.')
    visit '/'
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'whip_whipple@yahoo.com'
    fill_in :password, with: 'password12'
    click_button 'Login'
    visit '/'
    expect(page).to_not have_link('Users')
    visit '/admin/users'
    expect(page).to have_content('The page you were looking for doesn\'t exist.')
    visit '/'
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'bigskyguy@aol.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
    visit '/'
    expect(page).to_not have_link('Users')
    visit '/admin/users'
    expect(page).to have_content('The page you were looking for doesn\'t exist.')
  end
end
