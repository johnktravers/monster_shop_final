require 'rails_helper'

RSpec.describe 'As an admin on a merchant dashboard page' do
  before :each do
    create_admin
    create_user_with_addresses
    create_merchants_and_items
    create_orders
    login_as_admin

    @order_2.update(status: 1)
  end

  it 'can see the name and address of the merchant' do
    visit "/admin/merchants/#{@mike.id}"

    within '#merchant-info' do
      expect(page).to have_link(@mike.name)
      expect(page).to have_content('123 Paper Rd Denver, CO 80203')
    end

    click_link @mike.name

    expect(current_path).to eq("/merchants/#{@mike.id}")
  end

  it 'can see a list of pending orders' do
    visit "/admin/merchants/#{@mike.id}"

    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(1) }
      expect(page).to have_content('$20.00')
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(5) }
      expect(page).to have_content('$28.00')
    end
  end

  it 'can see a link to the merchants items' do
    visit "/admin/merchants/#{@mike.id}"

    within('#merchant-info') { click_link 'My Items' }

    expect(current_path).to eq("/merchants/#{@mike.id}/items")
  end

  it 'cannot access the merchant dashboard of a nonexistent merchant' do
    visit "/admin/merchants/9876519"

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end

end
