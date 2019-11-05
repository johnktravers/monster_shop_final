require 'rails_helper'

RSpec.describe 'As a merchant admin on the edit item page', type: :feature do
  before(:each) do
    create_merchants_and_items
    create_merchant_admin
    login_as_merchant_admin
  end

  it 'can see the prepopulated fields of that item' do
    visit '/merchant/items'
    within("#item-#{@paper.id}") { click_link 'Edit Item' }

    expect(current_path).to eq("/merchant/items/#{@paper.id}/edit")

    expect(page).to have_link('Lined Paper')
    expect(find_field('Name').value).to eq 'Lined Paper'
    expect(find_field('Price').value).to eq '20.0'
    expect(find_field('Description').value).to eq 'Great for writing on!'
    expect(find_field('Image').value).to eq('https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png')
    expect(find_field('Inventory').value).to eq '3'
  end

  it 'can change and update item with the form' do
    visit "/merchant/items/#{@paper.id}/edit"

    fill_in 'Name', with: 'GatorSkins'
    fill_in 'Price', with: 110
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588'
    fill_in 'Inventory', with: 11

    click_button 'Update Item'

    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('GatorSkins')
    expect(page).to_not have_content('Lined Paper')
    expect(page).to have_content('Price: $110')
    expect(page).to_not have_content('Price: $20')
    expect(page).to have_content('Inventory: 11')
    expect(page).to_not have_content('Inventory: 3')
    expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
    expect(page).to_not have_content('Great for writing on!')
  end

  it 'can see a flash message if entire form is not filled out' do
    visit "/merchant/items/#{@tire.id}/edit"

    fill_in 'Name', with: ''
    fill_in 'Price', with: 110
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: ''
    fill_in 'Inventory', with: 11

    click_button 'Update Item'

    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_button('Update Item')
  end
end
