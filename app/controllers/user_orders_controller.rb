class UserOrdersController < ApplicationController
  before_action :require_user

  def index
    @orders = current_user.orders
  end

  def show
    orders = current_user.orders.where(id: params[:id])
    if orders.empty?
      render_404
    else
      @order = orders.first
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(status: 3)
    order.item_orders.each do |item_order|
      if item_order.fulfilled?
        item = item_order.item
        item.increase_inventory(item_order.quantity)
        item.save
      end
      item_order.update(status: 2)
    end
    flash[:success] = ['Your order is now cancelled']
    redirect_to '/profile'
  end

  def create
    order = Order.create(user_id: current_user.id)
    if cart.contents.any? && order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = ['Your order has been successfully created!']
      redirect_to '/profile/orders'
    else
      flash[:error] = ["Please add something to your cart to place an order"]
      redirect_to '/items'
    end
  end

  private

  def require_user
    render_404 unless current_user
  end
end
