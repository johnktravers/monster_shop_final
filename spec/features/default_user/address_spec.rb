require 'rails_helper'

RSpec.describe 'As a default user on my profile page' do
  before :each do
    create_user_with_addresses
    login_as_default_user
  end

  it 'can create a new address by clicking a link' do
    visit '/profile'
    click_link 'New Address'

    expect(current_path).to eq('/profile/addresses/new')

    fill_in :nickname, with: 'Mountain Villa'
    fill_in :address, with: '132 Gold Ln'
    fill_in :city, with: 'Aspen'
    fill_in :state, with: 'CO'
    fill_in :zip, with: '80341'

    click_button 'Create Address'

    address = Address.last

    expect(current_path).to eq('/profile')
    expect(page).to have_content('You have successfully added a new address!')

    within "#address-#{address.id}" do
      expect(page).to have_content('Mountain Villa')
      expect(page).to have_content('132 Gold Ln')
      expect(page).to have_content('Aspen')
      expect(page).to have_content('CO')
      expect(page).to have_content('80341')
    end
  end

  it 'repopulates the form and shows error messages if not filled in' do
    visit '/profile/addresses/new'

    fill_in :nickname, with: 'Mountain Villa'
    fill_in :address, with: ''
    fill_in :city, with: 'Aspen'
    fill_in :state, with: ''
    fill_in :zip, with: ''

    click_button 'Create Address'

    expect(current_path).to eq('/profile/addresses')
    expect(page).to have_content('Address can\'t be blank')
    expect(page).to have_content('State can\'t be blank')
    expect(page).to have_content('Zip can\'t be blank')

    expect(page).to have_selector("input[value='Mountain Villa']")
    expect(page).to have_selector("input[value='Aspen']")
  end

  it 'can click a link to edit an address if there are no shipped orders' do
    @address_1.orders.create!
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

  it 'cannot edit an address that has shipped orders' do
    @address_1.orders.create!(status: 2)
    visit '/profile'

    within "#address-#{@address_1.id}" do
      expect(page).to_not have_link 'Edit Address'
      expect(page).to_not have_button 'Delete Address'
    end
  end
end
