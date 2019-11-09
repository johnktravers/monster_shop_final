require 'rails_helper'

RSpec.describe 'As an admin on the new merchant page', type: :feature do
  before :each do
    create_admin
    login_as_admin
  end

  it 'can create a new merchant by filling in the form' do
    visit merchants_path
    click_link 'New Merchant'

    expect(current_path).to eq('/admin/merchants/new')

    fill_in :name, with: "Sal's Calz(ones)"
    fill_in :address, with: '123 Kindalikeapizza Dr.'
    fill_in :city, with: 'Omaha'
    fill_in :state, with: 'NE'
    fill_in :zip, with: '74252'

    click_button 'Create Merchant'

    new_merchant = Merchant.last

    expect(current_path).to eq("/admin/merchants/#{new_merchant.id}")
    expect(page).to have_content("Sal's Calz(ones)")

    expect(new_merchant.name).to eq("Sal's Calz(ones)")
    expect(new_merchant.address).to eq('123 Kindalikeapizza Dr.')
    expect(new_merchant.city).to eq('Omaha')
    expect(new_merchant.state).to eq('NE')
    expect(new_merchant.zip).to eq('74252')
  end

  it 'cannot create a merchant if all fields are not filled in' do
    visit '/admin/merchants/new'

    fill_in :name, with: "Sal's Calz(ones)"
    fill_in :address, with: ''
    fill_in :city, with: 'Denver'
    fill_in :state, with: ''
    fill_in :zip, with: '80204'

    click_button 'Create Merchant'

    expect(current_path).to eq('/admin/merchants')
    expect(page).to have_content("Address can't be blank\nState can't be blank")

    expect(find_field('Name').value).to eq "Sal's Calz(ones)"
    expect(find_field('City').value).to eq 'Denver'
    expect(find_field('Zip').value).to eq '80204'
  end
end
