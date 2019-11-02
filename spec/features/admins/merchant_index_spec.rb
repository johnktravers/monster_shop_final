require 'rails_helper'

RSpec.describe "As an admin user" do
  before :each do
    @florist = Merchant.create(
      name: 'Florist Gump',
      address: '1523 N Main Street',
      city: 'Plaintree',
      state: 'MN',
      zip: 49155
    )

    @plumeria = Item.create(
      name: 'Plumeria Plant',
      description: 'The plumeria plant, also known as the "Scent of Hawaii", is like no other plant. It has electric hues of yellow, pink, and white blossoms that bloom from April until November. It also has a slender, geometric shape, and soft foliage that will branch and produce up to 60 flowers and over 100 blossoms each year.',
      price: 93.20,
      image: 'https://images.pexels.com/photos/63609/plumeria-flower-frangipani-plant-63609.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      active?: true,
      inventory: 14,
      merchant_id: @florist.id
    )
    @dahlia = Item.create(
      name: 'Dahlia Bulbs - Contraste Variety',
      description: 'A timeless dahlia favorite, introduced almost 60 years ago and still going strong. The big blooms measure up to eight inches across and have striking two-tone petals that are deep burgundy and purple with brilliant white tips.',
      price: 15.40,
      image: 'https://images.pexels.com/photos/910645/pexels-photo-910645.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      active?: true,
      inventory: 32,
      merchant_id: @florist.id
    )
    @rose = Item.create(
      name: 'Clementine Rose Bush',
      description: 'This rose bush grows long, pointed buds that open to classically shaped, four-inch blooms that have an artistic feel to their color - a rich apricot-blush, over-layed with copper tones toward the edge of the petals. The striking blooms are plentifully produced against bright-green, glossy leaves.',
      price: 45.63,
      image: 'https://images.pexels.com/photos/53007/rose-rose-family-rosaceae-composites-53007.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      active?: true,
      inventory: 8,
      merchant_id: @florist.id
    )
    @admin = User.create(
      name: "Dorian Bouchard",
      address: "7890 Montreal Blvd",
      city: "New Orleans",
      state: "LA", zip:
      70032,
      email: "ouibouchard@gmail.fr",
      password: "password1234",
      password_confirmation: "password1234",
      role:3
    )

    visit '/login'

    fill_in :email, with: 'ouibouchard@gmail.fr'
    fill_in :password, with: 'password1234'

    click_button 'Login'
  end

  it "I can disable/enable a merchant and show flash message" do
    visit '/merchants'

    within "#merchant-#{@florist.id}" do
      expect(page).to have_link("Disable")
      click_link "Disable"
    end

    expect(current_path).to eq('/merchants')

    expect(page).to have_content("disabled")

    expect(page).to have_content("#{@florist.name} has been disabled")

    within "#merchant-#{@florist.id}" do
      expect(page).to have_link("Enable")
      click_link "Enable"
    end

    expect(current_path).to eq('/merchants')

    expect(page).to have_content("enabled")

    expect(page).to have_content("#{@florist.name} has been enabled")
  end

  it "will disable all items associated with disabled merchant" do
    visit '/merchants'

    within "#merchant-#{@florist.id}" do
      click_link "Disable"
    end

    visit "/merchants/#{@florist.id}/items"

    expect(page).to_not have_css "#item-#{@plumeria.id}"
    expect(page).to_not have_css "#item-#{@dahlia.id}"
  end
end

describe "As a default user" do
  before :each do
    @florist = Merchant.create(
      name: 'Florist Gump',
      address: '1523 N Main Street',
      city: 'Plaintree',
      state: 'MN',
      zip: 49155
    )
    @cynthia = User.create(
      name: 'Cynthia Hall',
      address: '9247 E 42nd Avenue',
      city: 'Rochester',
      state: 'NY',
      zip: '48231',
      email: "cynthiahall@hotmail.com",
      password: "password",
      password_confirmation: "password"
    )

    visit '/login'

    fill_in :email, with: 'cynthiahall@hotmail.com'
    fill_in :password, with: 'password'

    click_button 'Login'
  end

  it "I can't disable/enable a merchant" do

    visit '/merchants'

    within "#merchant-#{@florist.id}" do
      expect(page).to_not have_link("Disable")
    end
  end
end
