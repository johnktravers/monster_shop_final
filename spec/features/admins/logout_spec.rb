require 'rails_helper'

RSpec.describe 'Admin logout' do
  before :each do
    create_admin
    login_as_admin
  end

  it 'can log out by going to logout path' do
    visit logout_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Ron Swanson, you have logged out!')

    within 'nav' do
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
      expect(page).to_not have_link('Logout')
    end
  end

  it 'can log out by clicking logout button in navbar' do
    within('nav') { click_link('Logout') }

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Ron Swanson, you have logged out!')

    within 'nav' do
      expect(page).to have_link('Login')
      expect(page).to have_link('Register')
      expect(page).to_not have_link('Logout')
    end
  end
end
