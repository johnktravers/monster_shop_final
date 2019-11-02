require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'status' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order = Order.create!(user_id: @user.id)
    end

    it 'can be created as unfulfilled' do
      item_order_1 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 13)

      expect(item_order_1.status).to eq('unfulfilled')
      expect(item_order_1.unfulfilled?).to eq(true)
    end

    it 'can be created as fulfilled' do
      item_order_2 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: 1)

      expect(item_order_2.status).to eq('fulfilled')
      expect(item_order_2.fulfilled?).to eq(true)
    end

    it 'can be created as cancelled' do
      item_order_3 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 5, status: 2)

      expect(item_order_3.status).to eq('cancelled')
      expect(item_order_3.cancelled?).to eq(true)
    end
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order = Order.create!(user_id: @user.id)
      @item_order_1 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 13)
      @item_order_2 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: 1)
      @item_order_3 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 5, status: 2)
    end

    it 'subtotal' do
      expect(@item_order_1.subtotal).to eq(1300)
    end

    it 'enough_inventory' do
      expect(@item_order_1.enough_inventory?).to eq(false)
      expect(@item_order_2.enough_inventory?).to eq(true)
      expect(@item_order_3.enough_inventory?).to eq(true)
    end
  end

end
