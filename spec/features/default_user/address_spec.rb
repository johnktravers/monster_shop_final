require 'rails_helper'

RSpec.describe 'As a default user on my profile page' do
  before :each do
    @user = User.create!(name: 'Gmoney', email: 'user@gmail.com', password: 'password123', password_confirmation: 'password123')
    @address_1 = @user.addresses.create(nickname: 'Home', address: '123 Lincoln St', city: 'Denver', state: 'CO', zip: '23840')
    @address_2 = @user.addresses.create(nickname: 'Work', address: '412 Broadway Blvd', city: 'Topeka', state: 'KS', zip: '34142')

    visit '/login'
    fill_in :email, with: 'user@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end

  it 'can click a link to edit an address' do
    visit '/profile'
    within("#address-#{@address_1.id}") { click_link 'Edit Address' }

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}/edit")

    fill_in :nickname, with: 'Mountain Villa'
    fill_in :address, with: '132 Gold Ln'
    fill_in :city, with: 'Aspen'
    fill_in :state, with: 'CO'
    fill_in :zip, with: '80341'

    click_button 'Update Address'

    expect(current_path).to eq('/profile')

    within "#address-#{@address_1.id}" do
      expect(page).to have_content('Mountain Villa')
      expect(page).to have_content('132 Gold Ln')
      expect(page).to have_content('Aspen')
      expect(page).to have_content('CO')
      expect(page).to have_content('80341')
    end
  end

  it 'sees flash messages if fields are left blank' do
    visit "/profile/addresses/#{@address_1.id}/edit"

    fill_in :nickname, with: ''
    fill_in :address, with: '132 Gold Ln'
    fill_in :city, with: ''
    fill_in :state, with: ''
    fill_in :zip, with: '80341'

    click_button 'Update Address'

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}")

    expect(page).to have_content('Nickname can\'t be blank')
    expect(page).to have_content('City can\'t be blank')
    expect(page).to have_content('State can\'t be blank')
  end

  it 'can delete an address that does not have orders' do
    visit '/profile'
    within("#address-#{@address_1.id}") { click_button 'Delete Address' }

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Your address has been successfully deleted!')
    expect(page).to_not have_css("#address-#{@address_1.id}")
  end

  it 'cannot delete an address that has orders' do
    @address_1.orders.create!
    visit '/profile'

    within "#address-#{@address_1.id}" do
      expect(page).to_not have_button 'Delete Address'
    end
  end
end
