require 'rails_helper'

RSpec.describe 'Merchant dashboard page for merchant employee' do
  before :each do
    @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test1@gmail.com", password: "password123", password_confirmation: "password123")

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 4)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = Order.create!(user_id: @user.id)
    @order_2 = Order.create!(user_id: @user.id)
    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 1)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 2)
    @order_2.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3)
    @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4)
    @order_2.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)

    @employee = @mike.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it 'can see the name and address of the merchant I work for' do
    visit '/merchant'

    within '#merchant-info' do
      expect(page).to have_link(@mike.name)
      expect(page).to have_content('123 Paper Rd Denver, CO 80203')
    end

    click_link @mike.name

    expect(current_path).to eq("/merchants/#{@mike.id}")
  end

  it 'can see a list of pending orders' do
    visit '/merchant'

    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
      expect(page).to have_content(@order_1.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(2) }
      expect(page).to have_content('$40.00')
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link("#{@order_2.id}")
      expect(page).to have_content(@order_2.created_at.strftime("%m/%d/%Y"))
      within('.total-quantity') { expect(page).to have_content(5) }
      expect(page).to have_content('$28.00')
    end
  end

  it 'can see a link to my merchants items' do
    within('#merchant-info') { click_link 'My Items' }

    expect(current_path).to eq('/merchant/items')
  end

end
