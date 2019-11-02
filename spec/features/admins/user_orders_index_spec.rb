require 'rails_helper'

RSpec.describe 'Admin User Orders Index Page', type: :feature do
  before :each do
    @user = User.create!(name: "Brad Paisley", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "user@gmail.com", password: "password123", password_confirmation: "password123")
    @admin = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "admin@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = @user.orders.create!
    @order_2 = @user.orders.create!
    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)
    @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 3)

    visit '/login'
    fill_in :email, with: 'admin@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end

  it 'shows order information' do
    visit "/admin/users/#{@user.id}/orders"

    expect(page).to have_content("Brad Paisley's Orders")

    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_content(@order_1.item_orders.count)
      expect(page).to have_content(@order_1.grandtotal)
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_2.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_2.status.capitalize)
      expect(page).to have_content(@order_2.item_orders.count)
      expect(page).to have_content(@order_2.grandtotal)
    end
  end

  it "has a link to the user order show page" do
    visit "/admin/users/#{@user.id}/orders"

    within("#order-#{@order_1.id}") { click_link("#{@order_1.id}") }

    expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order_1.id}")
  end

  it 'cannot go to an orders index page for a nonexistent user' do
    visit '/admin/users/2351/orders'

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
