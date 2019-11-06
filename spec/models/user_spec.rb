require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
    it { should validate_presence_of :email}
    it { should validate_uniqueness_of :email}
  end

  describe 'relationships' do
    it { should have_many :addresses }
    it { should belong_to(:merchant).optional }
  end

  describe 'roles' do
    it 'can be created as a default user' do
      user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")

      expect(user.role).to eq('default')
      expect(user.default?).to eq(true)
    end

    it 'can be created as a merchant employee' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      user = meg.users.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

      expect(user.role).to eq('merchant_employee')
      expect(user.merchant_employee?).to eq(true)
    end

    it 'can be created as a merchant admin' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      user = meg.users.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

      expect(user.role).to eq('merchant_admin')
      expect(user.merchant_admin?).to eq(true)
    end

    it 'can be created as an admin' do
      user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

      expect(user.role).to eq('admin')
      expect(user.admin?).to eq(true)
    end
  end

  describe 'instance methods' do
    it 'can titleize roles' do
      user = User.create!(name: "Gmoney", email: "test2@gmail.com", password: "password123", password_confirmation: "password123")
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      merchant_employee = meg.users.create!(name: "Gmoney", email: "test1@gmail.com", password: "password123", password_confirmation: "password123", role: 1)
      merchant_admin = meg.users.create!(name: "Gmoney", email: "test3@gmail.com", password: "password123", password_confirmation: "password123", role: 2)
      admin = User.create!(name: "Gmoney", email: "test4@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

      expect(user.titleize_role).to eq('Default')
      expect(merchant_employee.titleize_role).to eq('Merchant Employee')
      expect(merchant_admin.titleize_role).to eq('Merchant Admin')
      expect(admin.titleize_role).to eq('Admin')
    end

    it 'can retrieve all of a users orders' do
      user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      address_1 = user.addresses.create!(nickname: 'Home', address: '123 Lincoln St', city: 'Denver', state: 'CO', zip: '23840')
      address_2 = user.addresses.create!(nickname: 'Work', address: '646 Main St', city: 'Pittsburgh', state: 'PA', zip: '43824')

      order_1 = Order.create!(address_id: address_1.id)
      order_2 = Order.create!(address_id: address_2.id)
      order_3 = Order.create!(address_id: address_2.id)

      expect(user.orders).to eq([order_1, order_2, order_3])
    end

    it 'can see if a user has used a coupon' do
      create_user_with_addresses
      create_merchants_and_items
      create_coupons(@mike)

      expect(@user.used_coupon?(@coupon_1)).to eq(false)

      @address_1.orders.create(coupon_id: @coupon_1.id)

      expect(@user.used_coupon?(@coupon_1)).to eq(true)
    end
  end
end
