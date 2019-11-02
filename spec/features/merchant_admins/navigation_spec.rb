require 'rails_helper'

RSpec.describe "As a merchant admin" do
  it "cannot access certain paths" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
    merchant_admin = meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit '/merchants'

    expect(page).to have_content("Logged in as Gmoney")

    visit '/admin'

    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
end
