require 'rails_helper'

RSpec.describe "Cancel Order" do
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

    @order_1 = Order.create!(user_id: @user.id)
    @item_order_1 = @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2, status: 1)
    @item_order_2 = @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)
  end

  it "can cancel a pending order" do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    expect(current_path).to eq('/profile')

    expect(Order.last.status).to eq('cancelled')
    expect(Order.last.item_orders.first.status).to eq('cancelled')
    expect(Order.last.item_orders.last.status).to eq('cancelled')

    expect(page).to have_content('Your order is now cancelled')

    visit '/profile/orders'

    within "#order-#{@order_1.id}" do
      expect(page).to have_content("Cancelled")
    end
  end

  it "returns item quantity to merchant if item order is fulfilled" do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    visit '/items'

    within "#item-#{@tire.id}" do
      expect(page).to have_content('Inventory: 14')
    end

    within "#item-#{@paper.id}" do
      expect(page).to have_content('Inventory: 3')
    end
  end

  it "can see cancelled order status and no cancel button if order is cancelled" do
    visit "/profile/orders/#{@order_1.id}"

    click_button 'Cancel Order'

    visit "/profile/orders/#{@order_1.id}"

    within '.cart-table' do
      expect(page).to have_content('Cancelled')
    end

    expect(page).to_not have_button('Cancel Order')
  end
end
