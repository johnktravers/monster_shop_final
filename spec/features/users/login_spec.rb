require 'rails_helper'

RSpec.describe 'User login page' do
  describe 'default user' do
    before :each do
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    end
    it 'needs to login with valid credentials' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

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

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'billybob'

      click_button 'Login'

      expect(current_path).to eq('/login')
      expect(page).to have_content("Sorry, credentials were invalid. Please try again.")
    end

    it 'redirects to user profile from login path if user is logged in' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      visit '/login'

      expect(current_path).to eq('/profile')

      expect(page).to have_content('Sorry, you are already logged in.')
    end
  end

  describe 'merchant user' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      @employee = @meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test1@gmail.com", password: "password123", password_confirmation: "password123", role: 1)
      @admin = @meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)
    end
    it 'employee needs to login with valid credentials' do
      visit '/login'

      fill_in :email, with: 'test1@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("#{@employee.name}, you have successfully logged in.")
    end

    it 'admin needs to login with valid credentials' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      expect(current_path).to eq('/merchant')
      expect(page).to have_content("#{@admin.name}, you have successfully logged in.")
    end

    it 'redirects to merchant dashboard from login path if employee is logged in' do
      visit '/login'

      fill_in :email, with: 'test1@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      visit '/login'

      expect(current_path).to eq('/merchant')

      expect(page).to have_content('Sorry, you are already logged in.')
    end

    it 'redirects to merchant dashboard from login path if admin is logged in' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      visit '/login'

      expect(current_path).to eq('/merchant')

      expect(page).to have_content('Sorry, you are already logged in.')
    end
  end

  describe 'admin' do
    before :each do
      @admin = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 3)
    end
    it 'needs to login with valid credentials' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      expect(current_path).to eq('/admin')
      expect(page).to have_content("#{@admin.name}, you have successfully logged in.")
    end

    it 'redirects to admin dashboard from login path if admin is logged in' do
      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'

      visit '/login'

      expect(current_path).to eq('/admin')

      expect(page).to have_content('Sorry, you are already logged in.')
    end
  end
end
