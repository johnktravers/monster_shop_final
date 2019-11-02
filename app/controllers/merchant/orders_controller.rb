class Merchant::OrdersController < Merchant::BaseController
  def show
    @merchant = current_user.merchant
    orders = Order.where(id: params[:id])
    if orders.empty?
      render_404
    else
      @order = orders.first
    end
  end

  def update
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.update(status: 1)

    item = item_order.item
    item.reduce_inventory(item_order.quantity)
    item.save

    order = item_order.order
    if order.item_orders.all? { |item_ord| item_ord.fulfilled? }
      order.update(status: 0)
    end

    flash[:success] = ["You have successfully fulfilled #{item.name} for Order ##{item_order.order_id}"]
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end
end
