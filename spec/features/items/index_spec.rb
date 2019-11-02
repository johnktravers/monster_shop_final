require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "General item display" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_css "#item-#{@dog_bone.id}"
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "can click on item images to redirect to show page" do
      visit '/items'

      within("#item-#{@tire.id}") { find('.item-image').click }
      expect(current_path).to eq("/items/#{@tire.id}")

      visit '/items'

      within("#item-#{@pull_toy.id}") { find('.item-image').click }
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end
  end

  describe 'Item statistics' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @helmet = @meg.items.create(name: "Helmet", description: "Protect ya head", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 8)
      @chain = @meg.items.create(name: "Chain", description: "Protect ya head", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 8)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      @dog_bowl = @brian.items.create(name: "Dog Bowl", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @order_1 = Order.create!(user_id: @user.id)

      @order_1.item_orders.create!(item_id: @chain.id, price: @chain.price, quantity: 7)
      @order_1.item_orders.create!(item_id: @dog_bowl.id, price: @dog_bowl.price, quantity: 6)
      @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 5)
      @order_1.item_orders.create!(item_id: @pull_toy.id, price: @pull_toy.price, quantity: 4)
      @order_1.item_orders.create!(item_id: @dog_bone.id, price: @dog_bone.price, quantity: 3)
      @order_1.item_orders.create!(item_id: @helmet.id, price: @helmet.price, quantity: 2)
    end

    it 'can see a list of top five items by popularity' do
      visit '/items'

      within '.top-five' do
        within('#top-five-0') do
          expect(page).to have_link(@chain.name)
          expect(page).to have_content('Quantity Ordered: 7')
        end

        within('#top-five-1') do
          expect(page).to have_link(@dog_bowl.name)
          expect(page).to have_content('Quantity Ordered: 6')
        end

        within('#top-five-2') do
          expect(page).to have_link(@tire.name)
          expect(page).to have_content('Quantity Ordered: 5')
        end

        within('#top-five-3') do
          expect(page).to have_link(@pull_toy.name)
          expect(page).to have_content('Quantity Ordered: 4')
        end

        within('#top-five-4') do
          expect(page).to have_link(@dog_bone.name)
          expect(page).to have_content('Quantity Ordered: 3')
        end

        expect(page).to_not have_css('#top-five-5')
      end
    end

    it 'can see a list of bottom five items by popularity' do
      visit '/items'

      within '.bottom-five' do
        within('#bottom-five-0') do
          expect(page).to have_link(@helmet.name)
          expect(page).to have_content('Quantity Ordered: 2')
        end

        within('#bottom-five-1') do
          expect(page).to have_link(@dog_bone.name)
          expect(page).to have_content('Quantity Ordered: 3')
        end

        within('#bottom-five-2') do
          expect(page).to have_link(@pull_toy.name)
          expect(page).to have_content('Quantity Ordered: 4')
        end

        within('#bottom-five-3') do
          expect(page).to have_link(@tire.name)
          expect(page).to have_content('Quantity Ordered: 5')
        end

        within('#bottom-five-4') do
          expect(page).to have_link(@dog_bowl.name)
          expect(page).to have_content('Quantity Ordered: 6')
        end

        expect(page).to_not have_css('#bottom-five-6')
      end
    end

  end
end
