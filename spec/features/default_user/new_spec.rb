require 'rails_helper'

RSpec.describe 'User registration' do
  it 'can create a new user by filling out a form' do
    visit '/'
    click_on 'Register'

    expect(current_path).to eq('/register')

    fill_in :name, with: 'Cowboy Joe'
    fill_in :email, with: 'CowboyJoe@gmail.com'
    fill_in :password, with: 'YeeHaw123'
    fill_in :password_confirmation, with: 'YeeHaw123'

    click_button 'Create User'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('Congratulations Cowboy Joe, you have registered and are now logged in!')
  end

  it 'keeps a user logged in after registering' do
    visit '/register'

    fill_in :name, with: 'Cowboy Joe'
    fill_in :email, with: 'CowboyJoe@gmail.com'
    fill_in :password, with: 'YeeHaw123'
    fill_in :password_confirmation, with: 'YeeHaw123'

    click_button 'Create User'
    visit '/profile'

    expect(page).to have_content('Hello, Cowboy Joe')
  end

  it 'shows flash message when missing fields' do
    visit '/register'

    click_button 'Create User'

    expect(current_path).to eq('/users')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
  end

  it 'shows flash message when passwords dont match' do
    visit '/register'

    fill_in :password, with: 'Booya'
    fill_in :password_confirmation, with: 'Hello'

    click_button 'Create User'

    expect(current_path).to eq('/users')
    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  it 'prepopulates form fields after error message that email is not unique' do
    User.create(name: 'Gmoney', email: 'user@gmail.com', password: 'password123', password_confirmation: 'password123')

    visit '/register'

    fill_in :name, with: 'Cowboy Joe'
    fill_in :email, with: 'user@gmail.com'
    fill_in :password, with: 'YeeHaw123'
    fill_in :password_confirmation, with: 'YeeHaw123'

    click_button 'Create User'

    expect(current_path).to eq('/users')
    expect(page).to have_content('Email has already been taken')
    expect(page).to have_selector("input[value='Cowboy Joe']")
    expect(page).to_not have_selector("input[value='test@gmail.com']")
  end
end
