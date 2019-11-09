require 'rails_helper'

RSpec.describe 'As an admin on the users index page', type: :feature do
  before :each do
    @user_1 = User.create!(name: "Andy Dwyer", email: "user.1@gmail.com", password: "password", password_confirmation: "password")
    @user_2 = User.create!(name: "April Ludgate", email: "user.2@gmail.com", password: "password", password_confirmation: "password", role: 1)
    @user_3 = User.create!(name: "Tom Haverford", email: "user.3@gmail.com", password: "password", password_confirmation: "password", role: 2)

    create_admin
    login_as_admin
  end

  it 'can see all users and their roles' do
    visit root_path
    click_link 'Users'

    expect(current_path).to eq(admin_users_path)

    within "#user-#{@user_1.id}" do
      expect(page).to have_link(@user_1.name)
      expect(page).to have_content(@user_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Default')
    end

    within "#user-#{@user_2.id}" do
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_2.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Merchant Employee')
    end

    within "#user-#{@user_3.id}" do
      expect(page).to have_link(@user_3.name)
      expect(page).to have_content(@user_3.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Merchant Admin')
    end

    within "#user-#{@admin.id}" do
      expect(page).to have_link(@admin.name)
      expect(page).to have_content(@admin.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content('Admin')
    end
  end

  it 'can click on a users name to go to the admin user show page' do
    visit admin_users_path

    click_link @user_1.name

    expect(current_path).to eq("/admin/users/#{@user_1.id}")
  end
end
