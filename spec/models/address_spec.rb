require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }

    it { should validate_numericality_of(:zip).only_integer }
    it { should validate_length_of(:zip).is_equal_to(5) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
  end

  describe 'instance methods' do
    it 'shipped orders' do
      create_user_with_addresses
      order_1 = @address_1.orders.create!
      order_2 = @address_1.orders.create!(status: 2)
      order_3 = @address_1.orders.create!(status: 2)

      expect(@address_1.shipped_orders).to eq([order_2, order_3])
    end
  end
end
