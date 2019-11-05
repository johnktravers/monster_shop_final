class Coupon < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: true

  validates_numericality_of :percent_off,
    allow_nil: true,
    greater_than: 0,
    less_than_or_equal_to: 100

  validates_numericality_of :dollar_off,
    allow_nil: true,
    greater_than: 0

  validate :percent_off_xor_dollar_off
  belongs_to :merchant


  private

  def percent_off_xor_dollar_off
    unless percent_off.blank? ^ dollar_off.blank?
      errors.add(:base, 'Please specify either a percentage or dollar discount, not both')
    end
  end
end
