class Address < ApplicationRecord
  validates_presence_of :nickname, :address, :city, :state, :zip
  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5

  belongs_to :user
  has_many :orders

  def shipped_orders
    orders.where(status: 2)
  end
end
