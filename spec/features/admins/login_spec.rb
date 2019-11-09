require 'rails_helper'

RSpec.describe 'Admin login' do
  before :each do
    create_admin
  end

  it 'can login with valid credentials' do
    login_as_admin

    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content("#{@admin.name}, you have successfully logged in.")
  end

  it 'redirects to admin dashboard from login path if logged in' do
    login_as_admin
    visit login_path

    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content('Sorry, you are already logged in.')
  end
end
