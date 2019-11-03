require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      visit "/items/#{@tire.id}"
      click_button 'Add Item to Cart'

      visit "/items/#{@pull_toy.id}"
      click_button 'Add Item to Cart'

      visit "/items/#{@dog_bone.id}"
      click_button 'Add Item to Cart'

      visit "/items/#{@tire.id}"
      click_button 'Add Item to Cart'

      @user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @address = @user.addresses.create!(nickname: "Home", address: "123 Lincoln St", city: "Denver", state: "CO", zip: '23840')

      visit '/login'
      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'
      click_button 'Login'

      visit '/cart'
      click_link 'Checkout'
    end

    it 'can see the details of my cart' do
      within "#order-item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content(@meg.name)
        expect(page).to have_content("$100.00")
        expect(page).to have_content("2")
        expect(page).to have_content("$200.00")
      end

      within "#order-item-#{@pull_toy.id}" do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@brian.name)
        expect(page).to have_content("$10.00")
        expect(page).to have_content("1")
        expect(page).to have_content("$10.00")
      end

      within "#order-item-#{@dog_bone.id}" do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_content(@brian.name)
        expect(page).to have_content("$21.00")
        expect(page).to have_content("1")
        expect(page).to have_content("$21.00")
      end

      expect(page).to have_content("Grand Total: $231.00")
    end

    it 'shows a form to enter shipping information' do
      expect(page).to have_field('Nickname')
      expect(page).to have_field('Address')
      expect(page).to have_field('City')
      expect(page).to have_field('State')
      expect(page).to have_field('zip')

      expect(page).to have_button('Create Order')
    end

    it 'flashes messages and populates form for incomplete shipping info' do
      fill_in 'Nickname', with: nil
      fill_in 'Address',  with: '123 Burberry Ln'
      fill_in 'City',     with: nil
      fill_in 'State',    with: nil
      fill_in 'zip',      with: '13552'

      click_button 'Create Order'

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content("Nickname can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")

      expect(page).to have_selector("input[value='123 Burberry Ln']")
      expect(page).to have_selector("input[value='13552']")
    end

    it 'empties the cart after an order is made' do
      fill_in 'Nickname',    with: 'Joe Bob'
      fill_in 'Address', with: '1331 17th Ave'
      fill_in 'City',    with: 'Denver'
      fill_in 'State',   with: 'Colorado'
      fill_in 'zip',     with: '80202'

      click_button 'Create Order'

      within 'nav' do
        expect(page).to have_link('Cart (0)')
      end
    end

    it 'redirects to profile orders page after creating order and shows flash message' do
      fill_in 'Nickname', with: 'Joe Bob'
      fill_in 'Address',  with: '1331 17th Ave'
      fill_in 'City',     with: 'Denver'
      fill_in 'State',    with: 'Colorado'
      fill_in 'zip',      with: '80202'

      click_button 'Create Order'

      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content('Your order has been successfully created!')
    end

    # it 'cannot create an order without items', js: true do
    #   page.evaluate_script('window.history.back()')
    #
    #   click_on 'Checkout'
    #
    #   expect(current_path).to eq('/items')
    #   expect(page).to have_content("Please add something to your cart to place an order")
    # end
  end
end
