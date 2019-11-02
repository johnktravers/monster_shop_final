require 'rails_helper'

RSpec.describe 'When I visit an order show page as a merchant employee' do
  before :each do
    @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 4)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order = Order.create!(user_id: @user.id)
    @order.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 7)
    @order.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 104)
    @order.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 3)

    @mike.users.create!(name: "Harry", address: "123 Cherry St", city: "Augusta", state: "ME", zip: 23840, email: "test1@gmail.com", password: "password123", password_confirmation: "password123", role: 1)
    @meg.users.create!(name: "Harry", address: "123 Cherry St", city: "Augusta", state: "ME", zip: 23840, email: "test2@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

    visit '/login'

    fill_in :email, with: 'test1@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it 'can see customer info and info only for my items' do
    within("#order-#{@order.id}") { click_link("#{@order.id}") }

    expect(current_path).to eq("/merchant/orders/#{@order.id}")

    within '#customer-info' do
      expect(page).to have_content('Gmoney')
      expect(page).to have_content("123 Lincoln St Denver, CO 23840")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_link(@paper.name)
      expect(page).to have_content("3")
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("$20.00")
    end

    within "#item-#{@pencil.id}" do
      expect(page).to have_link(@pencil.name)
      expect(page).to have_content("104")
      expect(page).to have_css("img[src*='#{@pencil.image}']")
      expect(page).to have_content("$2.00")
    end


    expect(page).to_not have_css("#item-#{@tire.id}")
  end

  it 'can fulfill an unfulfilled item and it decreased item inventory' do
    visit "/merchant/orders/#{@order.id}"

    within("#item-#{@paper.id}") { click_button('Fulfill Item') }

    expect(current_path).to eq("/merchant/orders/#{@order.id}")
    expect(page).to have_content("You have successfully fulfilled Lined Paper for Order ##{@order.id}")

    within "#item-#{@paper.id}" do
      expect(page).to have_content('Fulfilled')
      expect(page).to_not have_button('Fulfill Item')
    end

    visit "/items/#{@paper.id}"

    expect(page).to have_content("Inventory: 1")
  end

  it 'cannot fulfill an item if it does not have enough inventory' do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@pencil.id}" do
      expect(page).to have_content('Unfulfilled')
      expect(page).to have_content("Cannot Fulfill (Not Enough Inventory)")
      expect(page).to_not have_button('Fulfill Item')
    end
  end

  it 'cannot fulfill a cancelled item order' do
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    click_link 'Your Orders'
    click_link "#{@order.id}"
    click_button 'Cancel Order'
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'test1@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@pencil.id}" do
      expect(page).to have_content('Cancelled')
      expect(page).to_not have_content('Fulfilled')
      expect(page).to_not have_content('Unfulfilled')
      expect(page).to_not have_button('Fulfill Item')
    end
  end

  it 'changes order status to packaged if all items are fulfilled' do
    click_link 'Logout'

    order = Order.create!(user_id: @user.id)
    order.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 7)
    order.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 50)

    visit '/login'
    fill_in :email, with: 'test1@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    visit "/merchant/orders/#{order.id}"
    within("#item-#{@pencil.id}") { click_button('Fulfill Item') }
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'test2@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    visit "/merchant/orders/#{order.id}"
    within("#item-#{@tire.id}") { click_button('Fulfill Item') }
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    visit '/profile/orders'
    within("#order-#{order.id}") { expect(page).to have_content('Packaged') }
  end
end
