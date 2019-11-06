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
  has_many :orders

  def eligible_item(item)
    merchant_id == item.merchant_id
  end

  def eligible_items(cart)
    if cart.class == Order
      cart.items.find_all { |item| item.merchant_id == merchant_id }
    else
      cart.keys.find_all { |item| item.merchant_id == merchant_id }
    end
  end

  def cart_subtotals(cart)
    subtotals = {}
    cart.each do |item, quantity|
      subtotals[item] = item.price * quantity
    end
    subtotals
  end

  def order_subtotals(order)
    subtotals = {}
    order.item_orders.each do |item_order|
      subtotals[item_order.item] = item_order.price * item_order.quantity
    end
    subtotals
  end

  def discount_subtotals(cart)
    if cart.class == Order
      subtotals = order_subtotals(cart)
    else
      subtotals = cart_subtotals(cart)
    end

    dollar_discount = dollar_off if dollar_off

    eligible_items(cart).each do |item|
      if percent_off
        subtotals[item] -= subtotals[item] * percent_off / 100
      else
        if dollar_discount >= subtotals[item]
          dollar_discount -= subtotals[item]
          subtotals[item] = 0
        else
          subtotals[item] -= dollar_discount
          dollar_discount = 0
        end
      end
    end
    subtotals
  end

  def discount_total(cart)
    discount_subtotals(cart).values.sum
  end


  private

  def percent_off_xor_dollar_off
    unless percent_off.blank? ^ dollar_off.blank?
      errors.add(:base, 'Please specify either a percentage or dollar discount, not both')
    end
  end
end
