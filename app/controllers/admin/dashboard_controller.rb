class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.all.order(:status)
  end

  def merchant_index
    merchants = Merchant.where(id: params[:id])
    if merchants.empty?
      render_404
    else
      @merchant = merchants.first
    end
  end
end
