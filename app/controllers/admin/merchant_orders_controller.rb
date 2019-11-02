class Admin::MerchantOrdersController < Admin::BaseController
  def show
    merchants = Merchant.where(id: params[:merchant_id])
    orders = Order.where(id: params[:order_id])
    if merchants.empty? || orders.empty?
      render_404
    else
      @merchant = merchants.first
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

    flash[:success] = ["You have successfully fulfilled #{item.name} for Order ##{params[:order_id]}"]
    redirect_to "/admin/merchants/#{params[:merchant_id]}/orders/#{params[:order_id]}"
  end
end
