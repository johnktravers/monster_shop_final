require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
    it { should validate_presence_of :address}
    it { should validate_presence_of :city}
    it { should validate_presence_of :state}
    it { should validate_presence_of :zip}
    it { should validate_presence_of :email}
    it { should validate_uniqueness_of :email}

    it { should validate_numericality_of(:zip).only_integer }
    it { should validate_length_of(:zip).is_equal_to(5) }
  end

  describe 'relationships' do
    it { should have_many :orders}
    it { should belong_to(:merchant).optional }
  end

  describe 'roles' do
    it 'can be created as a default user' do
      user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")

      expect(user.role).to eq('default')
      expect(user.default?).to eq(true)
    end

    it 'can be created as a merchant employee' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      user = meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 1)

      expect(user.role).to eq('merchant_employee')
      expect(user.merchant_employee?).to eq(true)
    end

    it 'can be created as a merchant admin' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      user = meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 2)

      expect(user.role).to eq('merchant_admin')
      expect(user.merchant_admin?).to eq(true)
    end

    it 'can be created as an admin' do
      user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

      expect(user.role).to eq('admin')
      expect(user.admin?).to eq(true)
    end
  end

  describe 'instance methods' do
    it 'can titleize roles' do
      user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test2@gmail.com", password: "password123", password_confirmation: "password123")
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd', city: 'Denver', state: 'CO', zip: 80203)
      merchant_employee = meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test1@gmail.com", password: "password123", password_confirmation: "password123", role: 1)
      merchant_admin = meg.users.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test3@gmail.com", password: "password123", password_confirmation: "password123", role: 2)
      admin = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test4@gmail.com", password: "password123", password_confirmation: "password123", role: 3)

      expect(user.titleize_role).to eq('Default')
      expect(merchant_employee.titleize_role).to eq('Merchant Employee')
      expect(merchant_admin.titleize_role).to eq('Merchant Admin')
      expect(admin.titleize_role).to eq('Admin')
    end
  end
end
