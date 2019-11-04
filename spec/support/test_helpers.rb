module TestHelpers

  #----------------------- Default User Methods -----------------------#

  def create_user_with_addresses
    @user = User.create!(name: 'Andy Dwyer', email: 'user@gmail.com', password: 'password123', password_confirmation: 'password123')
    @address_1 = @user.addresses.create(nickname: 'Home', address: '123 Lincoln St', city: 'Denver', state: 'CO', zip: '23840')
    @address_2 = @user.addresses.create(nickname: 'Work', address: '412 Broadway Blvd', city: 'Topeka', state: 'KS', zip: '34142')
  end

  def create_two_users_with_addresses
    @user_1 = User.create!(name: 'Andy Dwyer', email: 'user.1@gmail.com', password: 'password123', password_confirmation: 'password123')
    @address_1 = @user_1.addresses.create(nickname: 'Home', address: '123 Lincoln St', city: 'Denver', state: 'CO', zip: '23840')

    @user_2 = User.create!(name: 'April Ludgate', email: 'user.2@gmail.com', password: 'password123', password_confirmation: 'password123')
    @address_2 = @user_2.addresses.create!(nickname: 'Home', address: "456 Jefferson Ave", city: "Orlando", state: "FL", zip: '32810')
  end

  def create_merchants_and_items
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd', city: 'Denver', state: 'CO', zip: '80203')
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: '80203')
    @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
    @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
  end

  def create_orders
    @order_1 = Order.create!(address_id: @address_1.id)
    @order_2 = Order.create!(address_id: @address_2.id, status: 0)

    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2, status: 1)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)

    @order_2.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 3, status: 1)
    @order_2.item_orders.create!(item_id: @pencil.id, price: @pencil.price, quantity: 4, status: 1)
    @order_2.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1, status: 1)
  end

  def login_as_default_user
    visit '/login'
    fill_in :email, with: 'user@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end

  #----------------------- Admin Methods -----------------------#

  def create_admin
    @admin = User.create!(name: "Ron Swanson", email: "admin@gmail.com", password: "password123", password_confirmation: "password123", role: 3)
  end

  def login_as_admin
    visit '/login'
    fill_in :email, with: 'admin@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end

  #----------------------- Merchant Employee Methods -----------------------#

  def create_merchant_employees
    @mike_employee = @mike.users.create!(name: 'Andy Dwyer', email: 'mike.employee@gmail.com', password: 'password123', password_confirmation: 'password123', role: 1)
    @meg_employee = @meg.users.create!(name: "April Ludgate", email: "meg.employee@gmail.com", password: "password123", password_confirmation: "password123", role: 1)
  end

  def login_as_mikes_employee
    visit '/login'
    fill_in :email, with: 'mike.employee@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end

  def login_as_megs_employee
    visit '/login'
    fill_in :email, with: 'meg.employee@gmail.com'
    fill_in :password, with: 'password123'
    click_button 'Login'
  end


  #----------------------- Cart Methods -----------------------#

  def add_item_to_cart(item)
    visit "/items/#{item.id}"
    click_on 'Add Item to Cart'
  end
end
