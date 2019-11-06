require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }

    it { should validate_numericality_of(:percent_off).allow_nil }
    it { should validate_numericality_of(:percent_off).is_greater_than(0) }
    it { should validate_numericality_of(:percent_off).is_less_than_or_equal_to(100) }

    it { should validate_numericality_of(:dollar_off).allow_nil }
    it { should validate_numericality_of(:dollar_off).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end

  describe 'instance methods' do
    before :each do
      create_user_with_addresses
      create_merchants_and_items
      create_coupons(@mike)
      create_orders
      @cart = {@paper => 2, @pencil => 1, @tire => 6}
    end

    it 'eligible item' do
      expect(@coupon_1.eligible_item(@paper)).to eq(true)
      expect(@coupon_1.eligible_item(@tire)).to eq(false)
    end

    it 'eligible items' do
      expect(@coupon_1.eligible_items(@cart)).to eq([@paper, @pencil])
      expect(@coupon_1.eligible_items(@order_2)).to eq([@paper, @pencil])
    end

    it 'subtotals' do
      expect(@coupon_1.cart_subtotals(@cart)).to eq(
        { @paper => 40,
          @pencil => 2,
          @tire => 600 }
      )
      expect(@coupon_4.order_subtotals(@order_2)).to eq(
        { @paper => 20,
          @pencil => 8,
          @tire => 300 }
      )
    end

    it 'discount subtotals' do
      expect(@coupon_1.discount_subtotals(@cart)).to eq(
        { @paper => 24,
          @pencil => 1.2,
          @tire => 600 }
      )
      expect(@coupon_4.discount_subtotals(@cart)).to eq(
        { @paper => 0,
          @pencil => 1,
          @tire => 600 }
      )
      expect(@coupon_1.discount_subtotals(@order_2)).to eq(
        { @paper => 12,
          @pencil => 4.8,
          @tire => 300 }
      )
      expect(@coupon_2.discount_subtotals(@order_2)).to eq(
        { @paper => 10,
          @pencil => 8,
          @tire => 300 }
      )
    end

    it 'discount total' do
      expect(@coupon_1.discount_total(@cart)).to eq(625.2)
      expect(@coupon_4.discount_total(@cart)).to eq(601)

      expect(@coupon_1.discount_total(@order_2)).to eq(316.8)
      expect(@coupon_2.discount_total(@order_2)).to eq(318)
    end

  end
end
