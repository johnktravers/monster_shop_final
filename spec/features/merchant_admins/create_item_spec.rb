require 'rails_helper'

RSpec.describe 'As a merchant admin on the new item page', type: :feature do
  before(:each) do
    create_merchants_and_items
    create_merchant_admin
    login_as_merchant_admin
  end

  it 'can see a link to add a new item for that merchant' do
    visit "/merchant/items"

    expect(page).to have_link 'Add New Item'
  end

  it 'can add a new item by filling out a form' do
    visit '/merchant/items'

    name = 'Chamois Buttr'
    price = 18
    description = 'No more chaffin!'
    image_url = 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
    inventory = 25

    click_link 'Add New Item'

    expect(current_path).to eq('/merchant/items/new')
    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory

    click_button 'Create Item'

    new_item = Item.last

    expect(current_path).to eq('/merchant/items')
    expect(new_item.name).to eq(name)
    expect(new_item.price).to eq(price)
    expect(new_item.description).to eq(description)
    expect(new_item.image).to eq(image_url)
    expect(new_item.inventory).to eq(inventory)
    expect(new_item.active?).to be(true)
    expect("#item-#{new_item.id}").to be_present
    expect(page).to have_content(name)
    expect(page).to have_content("Price: $#{new_item.price}")
    expect(page).to have_css("img[src*='#{new_item.image}']")
    expect(page).to have_content('Active')
    expect(page).to have_content("Inventory: #{new_item.inventory}")

    expect(page).to have_content("#{new_item.name} has been successfully created")
  end

  it 'see an alert if I dont fully fill out the form and form is prepopulated' do
    visit '/merchant/items'

    name = ''
    price = 18
    description = 'No more chaffin'
    image_url = 'https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg'
    inventory = ''

    click_link 'Add New Item'

    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory

    click_button 'Create Item'

    expect(page).to have_content("Name can't be blank\nInventory can't be blank")

    expect(page).to have_selector("input[value='18.0']")
    expect(page).to have_selector("input[value='https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg']")

    expect(page).to have_button('Create Item')
  end

  it 'provides a default image if none is provided' do
    visit '/merchant/items'

    name = 'Chamois Buttr'
    price = 18
    description = 'No more chaffin!'
    inventory = 25

    click_link 'Add New Item'

    expect(current_path).to eq('/merchant/items/new')
    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :inventory, with: inventory

    click_button 'Create Item'

    expect(current_path).to eq('/merchant/items')

    within "#item-#{Item.last.id}" do
      expect(page).to have_css("img[src*='https://i.ytimg.com/vi/Xw1C5T-fH2Y/maxresdefault.jpg']")
    end
  end
end
