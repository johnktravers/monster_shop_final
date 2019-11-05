require 'rails_helper'

RSpec.describe 'As an admin on the edit merchant page' do
  before :each do
    create_merchants_and_items
    create_admin
    login_as_admin
  end

  it 'can see prepopulated info on that merchant in the edit form' do
    visit "/admin/merchants/#{@meg.id}"
    click_link 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@meg.id}/edit")
    expect(page).to have_link(@meg.name)

    expect(find_field('Name').value).to eq "Meg's Bike Shop"
    expect(find_field('Address').value).to eq '123 Bike Rd'
    expect(find_field('City').value).to eq 'Denver'
    expect(find_field('State').value).to eq 'CO'
    expect(find_field('Zip').value).to eq '80203'
  end

  it 'can edit merchant info by filling in the form and clicking submit' do
    visit "/admin/merchants/#{@meg.id}/edit"

    fill_in 'Name', with: "Meg's Super Cool Bike Shop"
    fill_in 'Address', with: '1234 New Bike Rd'
    fill_in 'City', with: 'Richmond'
    fill_in 'State', with: 'VA'
    fill_in 'Zip', with: '20134'

    click_button 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    expect(page).to have_content("Meg's Super Cool Bike Shop")
    expect(page).to have_content('1234 New Bike Rd Richmond, VA 20134')
  end

  it 'I see a flash message if i dont fully complete form' do
    visit "/admin/merchants/#{@meg.id}/edit"

    fill_in 'Name', with: ''
    fill_in 'Address', with: '1234 New Bike Rd.'
    fill_in 'City', with: ''
    fill_in 'State', with: 'CO'
    fill_in 'Zip', with: '80204'

    click_button 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    expect(page).to have_content("Name can't be blank\nCity can't be blank")
    expect(page).to have_button('Update Merchant')
  end
end
