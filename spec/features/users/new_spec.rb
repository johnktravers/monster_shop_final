require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates new user" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq("/register")

    fill_in :name, with: "Cowboy Joe"
    fill_in :address, with: "123 Ranch Dr"
    fill_in :city, with: "Austin"
    fill_in :state, with: "Texas"
    fill_in :zip, with: "78520"
    fill_in :email, with: "CowboyJoe@gmail.com"
    fill_in :password, with: "YeeHaw123"
    fill_in :password_confirmation, with: "YeeHaw123"

    click_button "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Congratulations #{User.last.name}, you have registered and are now logged in!")
  end

  it 'keeps a user logged in after registering' do
    visit "/register"

    fill_in :name, with: "Cowboy Joe"
    fill_in :address, with: "123 Ranch Dr"
    fill_in :city, with: "Austin"
    fill_in :state, with: "Texas"
    fill_in :zip, with: "78520"
    fill_in :email, with: "CowboyJoe@gmail.com"
    fill_in :password, with: "YeeHaw123"
    fill_in :password_confirmation, with: "YeeHaw123"

    click_button "Create User"

    visit '/profile'

    expect(page).to have_content('Hello, Cowboy Joe')
  end

  it "shows flash message when missing fields" do
    visit "/register"

    click_button "Create User"

    # expect(current_path).to eq("/register")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Address can't be blank")
    expect(page).to have_content("City can't be blank")
    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  it "shows flash message when passwords don't match" do
    visit "/register"

    fill_in :password, with: "Booya"
    fill_in :password_confirmation, with: "Hello"

    click_button "Create User"

    # expect(current_path).to eq("/register")
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it "prepopulates form fields after error message that email is not unique" do
    User.create(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")

    visit "/register"

    fill_in :name, with: "Cowboy Joe"
    fill_in :address, with: "123 Ranch Dr"
    fill_in :city, with: "Austin"
    fill_in :state, with: "Texas"
    fill_in :zip, with: "78520"
    fill_in :email, with: "test@gmail.com"
    fill_in :password, with: "YeeHaw123"
    fill_in :password_confirmation, with: "YeeHaw123"

    click_button "Create User"

    # expect(current_path).to eq("/register")
    expect(page).to have_content("Email has already been taken")
    expect(page).to have_selector("input[value='Cowboy Joe']")
    expect(page).to have_selector("input[value='123 Ranch Dr']")
    expect(page).to have_selector("input[value='Austin']")
    expect(page).to have_selector("input[value='Texas']")
    expect(page).to have_selector("input[value='78520']")
    expect(page).to_not have_selector("input[value='test@gmail.com']")
  end
end
