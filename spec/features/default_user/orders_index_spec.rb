require 'rails_helper'

RSpec.describe 'User Profile Orders Page', type: :feature do
  before :each do
    @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    visit '/login'
    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = Order.create!(user_id: @user.id)
    @order_2 = Order.create!(user_id: @user.id)
    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)
    @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 3)
  end

  it 'shows order information' do
    visit '/profile/orders'

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

  it "has a link to the order show page" do
    visit '/profile/orders'

    click_link("#{@order_1.id}")

    expect(current_path).to eq("/profile/orders/#{@order_1.id}")
  end
end
