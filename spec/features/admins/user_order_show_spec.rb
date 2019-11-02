require 'rails_helper'

RSpec.describe "Order show page" do
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
    click_button 'Login'  end

  it "shows order information" do
    visit "/admin/users/#{@user.id}/orders/#{@order_1.id}"

    within "#order-info" do
      expect(page).to have_content(@order_1.id)
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.updated_at.strftime("%m/%d/%Y"))
      expect(page).to have_content(@order_1.status.capitalize)
      expect(page).to have_content(@order_1.item_orders.count)
      expect(page).to have_content(@order_1.grandtotal)
    end
  end

  it "shows item information" do
    visit "/admin/users/#{@user.id}/orders/#{@order_1.id}"

    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content("2")
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content("$200.00")
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content(@paper.name)
      expect(page).to have_content(@paper.description)
      expect(page).to have_content("$#{@paper.price}")
      expect(page).to have_content("1")
      expect(page).to have_css("img[src*='#{@paper.image}']")
      expect(page).to have_content("$20.00")
    end

    expect(page).to_not have_css("#item-#{@pencil.id}")
  end

  it 'cannot go to an order show page for a nonexistent user or order' do
    visit "/admin/users/#{@user.id}/orders/2546"
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')

    visit "/admin/users/2315/orders/1"
    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end
end
