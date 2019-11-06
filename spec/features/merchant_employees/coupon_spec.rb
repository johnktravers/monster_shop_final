require 'rails_helper'

RSpec.describe 'As a merchant employee on my coupons page' do
  before :each do
    create_merchants_and_items
    create_merchant_employees
    login_as_mikes_employee
    create_coupons(@mike)
  end

  it 'can click a link to merchant coupons index from merchant dashboard' do
    visit '/merchant'
    click_link 'My Coupons'

    expect(current_path).to eq('/merchant/coupons')
  end

  it 'can see existing coupons for my merchant' do
    visit '/merchant/coupons'

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content('Halloween Sale')
      expect(page).to have_content('40% Off')
    end

    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content('Member Discount')
      expect(page).to have_content('$10.00 Off')
    end

    within "#coupon-#{@coupon_3.id}" do
      expect(page).to have_content('Happy Holidays')
      expect(page).to have_content('20% Off')
    end
  end

  it 'can create a new coupon if merchant has less than five' do
    visit '/merchant/coupons'
    click_link 'New Coupon'

    expect(current_path).to eq('/merchant/coupons/new')

    fill_in :name, with: 'Senior Discount'
    fill_in :percent_off, with: 15
    fill_in :dollar_off, with: ''
    click_button 'Create Coupon'

    new_coupon = Coupon.last

    expect(current_path).to eq('/merchant/coupons')
    expect(page).to have_content('You have successfully created a Senior Discount coupon!')

    within "#coupon-#{new_coupon.id}" do
      expect(page).to have_content('Senior Discount')
      expect(page).to have_content('15% Off')
    end
  end

  it 'cannot create a new coupon if merchant already has five' do
    @mike.coupons.create(name: 'Your Lucky Day', percent_off: 30)
    @mike.coupons.create(name: 'Happy 4th', dollar_off: 25)

    visit '/merchant/coupons'
    expect(page).to_not have_link 'New Coupon'
  end

  it 'sees a flash message if both discount fields are filled in' do
    visit '/merchant/coupons/new'

    fill_in :name, with: ''
    fill_in :percent_off, with: 15
    fill_in :dollar_off, with: 24
    click_button 'Create Coupon'

    expect(current_path).to eq('/merchant/coupons')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Please specify either a percentage or dollar discount, not both')
    expect(page).to have_field(:name)
  end

  it 'sees a flash message if name is not unique' do
    visit '/merchant/coupons/new'

    fill_in :name, with: 'Happy Holidays'
    fill_in :percent_off, with: ''
    fill_in :dollar_off, with: 24
    click_button 'Create Coupon'

    expect(current_path).to eq('/merchant/coupons')
    expect(page).to have_content('Name has already been taken')
    expect(page).to have_field(:name)
  end

  it 'can edit an existing coupon if it has not been used' do
    visit '/merchant/coupons'
    within("#coupon-#{@coupon_1.id}") { click_link 'Edit Coupon' }

    expect(current_path).to eq("/merchant/coupons/#{@coupon_1.id}/edit")

    fill_in :name, with: 'Senior Discount'
    fill_in :percent_off, with: 15
    fill_in :dollar_off, with: ''
    click_button 'Update Coupon'

    expect(current_path).to eq('/merchant/coupons')
    expect(page).to have_content('You have successfully updated your Senior Discount coupon!')

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content('Senior Discount')
      expect(page).to_not have_content('Halloween Sale')
      expect(page).to have_content('15% Off')
      expect(page).to_not have_content('50% Off')
    end
  end

  it 'cannot edit a coupon that does not exist' do
    visit "/merchant/coupons/2512/edit"

    expect(page).to have_content('The page you were looking for doesn\'t exist (404)')
  end

  it 'can delete an existing coupon if it has not been used' do
    visit '/merchant/coupons'
    within("#coupon-#{@coupon_1.id}") { click_button 'Delete Coupon' }

    expect(current_path).to eq('/merchant/coupons')
    expect(page).to have_content('You have successfully deleted your Halloween Sale coupon!')

    expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
  end

  it 'cannot edit or delete a coupon that has been used' do
    create_user_with_addresses
    @address_1.orders.create!(coupon_id: @coupon_1.id)

    visit '/merchant/coupons'

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to_not have_link('Edit Coupon')
      expect(page).to_not have_button('Delete Coupon')
    end
  end
end
