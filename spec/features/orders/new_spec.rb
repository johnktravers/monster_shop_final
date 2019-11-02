RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@paper.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@tire.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add Item to Cart"

      @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      visit '/login'
      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'
      click_button 'Login'

      visit "/cart"
      click_on "Checkout"
    end

    it 'redirects to profile orders page after creating order and shows flash message' do

      expect(current_path).to eq("/profile/orders")

      expect(page).to have_content('Your order has been successfully created!')

      expect(page).to have_content('Cart (0)')
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
