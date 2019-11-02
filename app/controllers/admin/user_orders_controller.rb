class Admin::UserOrdersController < Admin::BaseController
  def index
    users = User.where(id: params[:id])
    if users.empty?
      render_404
    else
      @orders = users.first.orders
    end
  end

  def show
    users = User.where(id: params[:user_id])
    if users.empty?
      render_404
    else
      orders = users.first.orders.where(id: params[:order_id])
      if orders.empty?
        render_404
      else
        @order = orders.first
      end
    end
  end

  def update
    order = Order.find(params[:order_id])
    order.update(status: 2)
    redirect_to '/admin'
  end
end
