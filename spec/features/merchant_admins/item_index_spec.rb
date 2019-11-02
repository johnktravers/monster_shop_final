require 'rails_helper'

RSpec.describe 'Merchant Items Index Page', type: :feature do
  before(:each) do
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @merchant_admin = @brian.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it 'shows all merchant items' do
    visit '/merchant/items'

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_content("Price: $#{@pull_toy.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_link(@dog_bone.name)
      expect(page).to have_content(@dog_bone.description)
      expect(page).to have_content("Price: $#{@dog_bone.price}")
      expect(page).to have_content("Inactive")
      expect(page).to have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
    end
  end

  it 'can activate an inactive item' do
    visit '/merchant/items'

    within "#item-#{@dog_bone.id}" do
      click_link 'Activate'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('Dog Bone is now for sale')

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_content('Active')
      expect(page).to have_link('Deactivate')
    end
  end

  it 'can deactivate an active item' do
    visit '/merchant/items'

    within "#item-#{@pull_toy.id}" do
      click_link 'Deactivate'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('Pull Toy is no longer for sale')

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content('Inactive')
      expect(page).to have_link('Activate')
    end
  end

  it 'can delete an item' do
    visit '/merchant/items'

    within "#item-#{@dog_bone.id}" do
      click_link 'Delete Item'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to_not have_css("#item-#{@dog_bone.id}")

    expect(page).to_not have_link(@dog_bone.name)
    expect(page).to_not have_content(@dog_bone.description)
    expect(page).to_not have_content("Price: $#{@dog_bone.price}")
    expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
    expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")

    expect(page).to have_content("Dog Bone has been successfully deleted")
  end
end
