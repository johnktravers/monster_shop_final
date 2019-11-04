require 'rails_helper'

RSpec.describe 'Merchant employee login' do
  before :each do
    create_merchants_and_items
    create_merchant_employees
  end

  it 'can login with valid credentials' do
    login_as_megs_employee

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("#{@meg_employee.name}, you have successfully logged in.")
  end

  it 'cannot login with invalid credentials' do
    visit '/login'
    fill_in :email, with: 'meg.employee@gmail.com'
    fill_in :password, with: 'billybob'
    click_button 'Login'

    expect(current_path).to eq('/login')
    expect(page).to have_content('Sorry, credentials were invalid. Please try again.')
  end

  it 'redirects to merchant dashboard from login path if logged in' do
    login_as_megs_employee
    visit '/login'

    expect(current_path).to eq('/merchant')
    expect(page).to have_content('Sorry, you are already logged in.')
  end
end
