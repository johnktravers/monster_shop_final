require 'rails_helper'

RSpec.describe 'As an admin user on the merchant index page' do
  before :each do
    create_admin
    create_merchants_and_items
    login_as_admin
  end

  it 'can disable/enable a merchant and it shows a flash message' do
    visit merchants_path

    within "#merchant-#{@meg.id}" do
      expect(page).to have_link('Disable')
      click_link 'Disable'
    end

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content('disabled')
    expect(page).to have_content("#{@meg.name} has been disabled")

    within "#merchant-#{@meg.id}" do
      expect(page).to have_link('Enable')
      click_link 'Enable'
    end

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content('enabled')
    expect(page).to have_content("#{@meg.name} has been enabled")
  end

  it 'will disable all items associated with disabled merchant' do
    visit merchants_path

    within "#merchant-#{@mike.id}" do
      click_link 'Disable'
    end

    visit "/merchants/#{@mike.id}/items"

    expect(page).to_not have_css "#item-#{@paper.id}"
    expect(page).to_not have_css "#item-#{@pencil.id}"
  end

  it 'cannot disable a merchant as a default user' do
    click_link 'Logout'
    login_as_default_user

    visit merchants_path

    within "#merchant-#{@meg.id}" do
      expect(page).to_not have_link('Disable')
    end
  end
end
