require 'rails_helper'

RSpec.describe 'Admin order shipment' do
  before :each do
    @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "user@gmail.com", password: "password123", password_confirmation: "password123")

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = @user.orders.create!(status: 0)
    @order_2 = @user.orders.create!
    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2, status: 1)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)
    @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 3)

    @admin = User.create!(name: "Harry", address: "123 Cherry St", city: "Augusta", state: "ME", zip: 23840, email: "admin@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

    visit '/login'

    fill_in :email, with: 'admin@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end
  
  it 'can see packaged orders that are ready to ship' do
    visit '/admin'

    within "#order-#{@order_1.id}" do
      expect(page).to have_content('Ready for Shipment')
      expect(page).to have_button('Ship Order')
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_content('Not Ready for Shipment')
      expect(page).to_not have_button('Ship Order')
    end
  end

  it 'can click a button to ship packaged orders' do
    visit '/admin'

    within("#order-#{@order_1.id}") { click_button('Ship Order') }

    expect(current_path).to eq('/admin')
    within("#order-#{@order_1.id}") { expect(page).to have_content('Shipped') }
  end

  it 'a user cannot cancel an order after it has been shipped' do
    visit '/admin'
    within("#order-#{@order_1.id}") { click_button('Ship Order') }
    click_link 'Logout'

    visit '/login'
    fill_in :email, with: 'user@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    visit "/profile/orders/#{@order_1.id}"

    expect(page).to_not have_button 'Cancel Order'
  end

end
