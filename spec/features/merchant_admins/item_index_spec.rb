require 'rails_helper'

RSpec.describe 'Merchant Items Index Page', type: :feature do
  before(:each) do
    create_merchants_and_items
    create_merchant_admin
    login_as_merchant_admin

    @chain = @mike.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5, active?: false)
  end

  it 'shows all merchant items' do
    visit '/merchant/items'

    within "#item-#{@paper.id}" do
      expect(page).to have_link(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content("Price: $#{@paper.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@paper.inventory}")
      expect(page).to have_css("img[src*='#{@paper.image}']")
    end

    within "#item-#{@pencil.id}" do
      expect(page).to have_link(@pencil.name)
      expect(page).to have_content(@pencil.description)
      expect(page).to have_content("Price: $#{@pencil.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@pencil.inventory}")
      expect(page).to have_css("img[src*='#{@pencil.image}']")
    end

    within "#item-#{@chain.id}" do
      expect(page).to have_link(@chain.name)
      expect(page).to have_content(@chain.description)
      expect(page).to have_content("Price: $#{@chain.price}")
      expect(page).to have_content("Inactive")
      expect(page).to have_content("Inventory: #{@chain.inventory}")
      expect(page).to have_css("img[src*='#{@chain.image}']")
    end
  end

  it 'can activate an inactive item' do
    visit '/merchant/items'

    within "#item-#{@chain.id}" do
      click_link 'Activate'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('Chain is now for sale')

    within "#item-#{@chain.id}" do
      expect(page).to have_content('Active')
      expect(page).to have_link('Deactivate')
    end
  end

  it 'can deactivate an active item' do
    visit '/merchant/items'

    within "#item-#{@paper.id}" do
      click_link 'Deactivate'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to have_content('Lined Paper is no longer for sale')

    within "#item-#{@paper.id}" do
      expect(page).to have_content('Inactive')
      expect(page).to have_link('Activate')
    end
  end

  it 'can delete an item' do
    visit '/merchant/items'

    within "#item-#{@pencil.id}" do
      click_link 'Delete Item'
    end

    expect(current_path).to eq('/merchant/items')

    expect(page).to_not have_css("#item-#{@pencil.id}")

    expect(page).to_not have_link(@pencil.name)
    expect(page).to_not have_content(@pencil.description)
    expect(page).to_not have_content("Price: $#{@pencil.price}")
    expect(page).to_not have_content("Inventory: #{@pencil.inventory}")
    expect(page).to_not have_css("img[src*='#{@pencil.image}']")

    expect(page).to have_content('Yellow Pencil has been successfully deleted')
  end
end
