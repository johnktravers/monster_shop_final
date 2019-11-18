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

    reduce_item_inventory(item_order)
    package_order_if_fulfilled(item_order.order)

    flash[:success] = ["You have successfully fulfilled #{item_order.item.name} for Order ##{item_order.order_id}"]
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end


  private

  def reduce_item_inventory(item_order)
    item = item_order.item
    item.reduce_inventory(item_order.quantity)
    item.save
  end

  def package_order_if_fulfilled(order)
    if order.item_orders.all? { |item_ord| item_ord.fulfilled? }
      order.update(status: 0)
    end
  end
end
