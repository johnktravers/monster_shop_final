class Order <ApplicationRecord
  validates_presence_of :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :address
  belongs_to :coupon, optional: true

  enum status: %w(packaged pending shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_item_quantity
    item_orders.sum(:quantity)
  end

  def user
    address.user
  end
end
