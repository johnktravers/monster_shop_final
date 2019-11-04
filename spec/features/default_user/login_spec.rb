require 'rails_helper'

RSpec.describe 'Default user login' do
  before :each do
    create_user_with_addresses
  end

  it 'needs to login with valid credentials' do
    login_as_default_user

    expect(current_path).to eq('/profile')
    expect(page).to have_content("#{@user.name}, you have successfully logged in.")

    within 'nav' do
      expect(page).to have_link('Logout')
      expect(page).to_not have_link('Login')
      expect(page).to_not have_link('Register')
    end
  end

  it 'cannot login with invalid credentials' do
    visit '/login'
    fill_in :email, with: 'user@gmail.com'
    fill_in :password, with: 'billybob'
    click_button 'Login'

    expect(current_path).to eq('/login')
    expect(page).to have_content('Sorry, credentials were invalid. Please try again.')
  end

  it 'redirects to user profile from login path if user is logged in' do
    login_as_default_user
    visit '/login'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Sorry, you are already logged in.')
  end
end
