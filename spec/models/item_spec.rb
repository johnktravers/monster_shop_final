require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should_not allow_value(nil).for(:active?) }

    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:inventory).only_integer }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 10)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(user_id: @user.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'can find the quantity ordered of an item' do
      order_1 = Order.create!(user_id: @user.id)
      order_2 = Order.create!(user_id: @user.id)

      order_1.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 7)
      order_2.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 3)

      expect(@chain.quantity_ordered).to eq(10)
    end

    it 'can reduce inventory quantity' do
      @chain.reduce_inventory(6)

      expect(@chain.inventory).to eq(4)
    end

    it 'can increase inventory quantity' do
      @chain.increase_inventory(6)

      expect(@chain.inventory).to eq(16)
    end
  end

  describe "class methods" do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @helmet = @meg.items.create(name: "Helmet", description: "Protect ya head", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active?: false, inventory: 8)
      @chain = @meg.items.create(name: "Chain", description: "Protect ya head", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active?: false, inventory: 8)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: false, inventory: 21)
      @dog_bowl = @brian.items.create(name: "Dog Bowl", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: false, inventory: 21)

      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order_1 = Order.create!(user_id: @user.id)

      @order_1.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 7)
      @order_1.item_orders.create!(item_id: @dog_bowl.id, price: @dog_bowl.price, quantity: 6)
      @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 5)
      @order_1.item_orders.create!(item_id: @pull_toy.id, price: @pull_toy.price, quantity: 4)
      @order_1.item_orders.create!(item_id: @dog_bone.id, price: @dog_bone.price, quantity: 3)
      @order_1.item_orders.create!(item_id: @helmet.id, price: @helmet.price, quantity: 2)
    end

    it "can return only active items" do
      expect(Item.active_only).to eq([@tire, @pull_toy])
    end

    it 'can calculate top five most popular items' do
      expect(Item.top_five_ordered).to eq([@chain, @dog_bowl, @tire, @pull_toy, @dog_bone])
    end

    it 'can calculate five least popular items' do
      expect(Item.bottom_five_ordered).to eq([@helmet, @dog_bone, @pull_toy, @tire, @dog_bowl])
    end
  end
end
