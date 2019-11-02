require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order_1 = Order.create!(user_id: @user.id)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_item_quantity' do
      expect(@order_1.total_item_quantity).to eq(5)
    end
  end

  describe 'status' do
    before :each do
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order_1 = Order.create!(user_id: @user.id, status: 0)
      @order_2 = Order.create!(user_id: @user.id)
      @order_3 = Order.create!(user_id: @user.id, status: 2)
      @order_4 = Order.create!(user_id: @user.id, status: 3)
    end

    it 'can be created as a packaged order' do
      expect(@order_1.status).to eq('packaged')
      expect(@order_1.packaged?).to eq(true)
    end

    it 'can be created as a pending order' do
      expect(@order_2.status).to eq('pending')
      expect(@order_2.pending?).to eq(true)
    end

    it 'can be created as a shipped order' do
      expect(@order_3.status).to eq('shipped')
      expect(@order_3.shipped?).to eq(true)
    end

    it 'can be created as a cancelled order' do
      expect(@order_4.status).to eq('cancelled')
      expect(@order_4.cancelled?).to eq(true)
    end
  end
end
