require 'rails_helper'

RSpec.describe 'As a default user on my profile page' do
  before :each do
    create_user_with_addresses
    login_as_default_user
  end

  it 'can see all profile data expect password' do
    visit profile_path

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
    end

    within "#address-#{@address_1.id}" do
      expect(page).to have_content(@address_1.nickname)
      expect(page).to have_content(@address_1.address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zip)
    end

    within "#address-#{@address_2.id}" do
      expect(page).to have_content(@address_2.nickname)
      expect(page).to have_content(@address_2.address)
      expect(page).to have_content(@address_2.city)
      expect(page).to have_content(@address_2.state)
      expect(page).to have_content(@address_2.zip)
    end
  end

  it 'can prepopulate form to update profile info' do
    visit profile_path

    click_link 'Edit Your Info'

    expect(current_path).to eq('/profile/edit')

    expect(page).to have_selector("input[value='Andy Dwyer']")
    expect(page).to have_selector("input[value='user@gmail.com']")
  end

  it 'can click a button to edit profile data' do
    visit '/profile/edit'

    fill_in :name, with: 'Billy Bob'
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('You have succesfully updated your information!')

    within '.profile-info' do
      expect(page).to have_content('Billy Bob')
      expect(page).to have_content('billy.bob@gmail.com')
    end
  end

  it 'sees flash messages if fields are left blank' do
    visit '/profile/edit'

    fill_in :name, with: ''
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Name can't be blank")
  end

  it 'sees flash messages if email is not unique' do
    User.create!(name: 'Hank Smith', email: 'hank@gmail.com', password: 'password123', password_confirmation: 'password123')
    visit '/profile/edit'

    fill_in :name, with: 'Billy Bob'
    fill_in :email, with: 'hank@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('Email has already been taken')
  end

  it 'can click a button to update password' do
    visit profile_path

    click_link 'Change Your Password'

    expect(current_path).to eq('/profile/edit')

    fill_in :password, with: 'gmoneyisgreat'
    fill_in :password_confirmation, with: 'gmoneyisgreat'

    click_button 'Update Password'

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('You have successfully updated your password!')
  end

  it 'cannot change password if password field is blank' do
    visit '/profile/edit?info=false'

    fill_in :password, with: ''
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq(profile_path)

    expect(page).to have_content('Please fill in both password fields')

    expect(page).to have_field :password
    expect(page).to have_field :password_confirmation
  end

  it "cannot change password if both fields are filled in but don't match" do
    visit '/profile/edit?info=false'

    fill_in :password, with: 'gmoneyiswack'
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq(profile_path)

    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  it "shows a link to orders if user has orders" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: '80203')
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    order_1 = Order.create!(address_id: @address_1.id)
    order_1.item_orders.create!(item_id: tire.id, price: tire.price, quantity: 2)

    visit profile_path

    click_link 'Your Orders'

    expect(current_path).to eq('/profile/orders')
  end

  it "does't have link to orders if user doesn't have any orders" do
    visit profile_path

    expect(page).to_not have_link('Your Orders')
  end

  it 'shows a link to edit each address' do
    visit profile_path
    within("#address-#{@address_1.id}") { click_link 'Edit Address' }

    expect(current_path).to eq("/profile/addresses/#{@address_1.id}/edit")
  end
end
