require 'rails_helper'

RSpec.describe 'User logout' do

  describe 'default user' do
    before :each do
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")

      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'
    end

    it 'can log out by going to logout path' do
      visit '/logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'can log out by clicking logout button in navbar' do
      within('nav') { click_link('Logout') }

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'empties the cart after a user logs out' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

      visit "/items/#{paper.id}"
      click_button("Add Item to Cart")

      within('nav') { expect(page).to have_link('Cart (1)') }

      visit '/logout'

      within('nav') { expect(page).to have_link('Cart (0)') }
    end
  end

  describe 'merchant_employee' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      @merchant_employee = @meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'
    end

    it 'can log out by going to logout path' do
      visit '/logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'can log out by clicking logout button in navbar' do
      within('nav') { click_link('Logout') }

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'empties the cart after a user logs out' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

      visit "/items/#{paper.id}"
      click_button("Add Item to Cart")

      within('nav') { expect(page).to have_link('Cart (1)') }

      visit '/logout'

      within('nav') { expect(page).to have_link('Cart (0)') }
    end
  end

  describe 'merchant admin' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      @merchant_admin = @meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'
    end

    it 'can log out by going to logout path' do
      visit '/logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'can log out by clicking logout button in navbar' do
      within('nav') { click_link('Logout') }

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'empties the cart after a user logs out' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)

      visit "/items/#{paper.id}"
      click_button("Add Item to Cart")

      within('nav') { expect(page).to have_link('Cart (1)') }

      visit '/logout'

      within('nav') { expect(page).to have_link('Cart (0)') }
    end
  end

  describe 'admin' do
    before :each do
      @admin = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

      visit '/login'

      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'

      click_button 'Login'
    end

    it 'can log out by going to logout path' do
      visit '/logout'

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end

    it 'can log out by clicking logout button in navbar' do
      within('nav') { click_link('Logout') }

      expect(current_path).to eq('/')
      expect(page).to have_content('Gmoney, you have logged out!')

      within 'nav' do
        expect(page).to have_link('Login')
        expect(page).to have_link('Register')
        expect(page).to_not have_link('Logout')
      end
    end
  end
end
