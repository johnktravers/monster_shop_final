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
  end
end
