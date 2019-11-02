class Admin::MerchantsController < Admin::BaseController
  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle! :enabled?
    merchant.items.each do |item|
      item.update(active?: merchant.enabled?)
    end
    if merchant.enabled?
        flash[:success] = ["#{merchant.name} has been enabled"]
    else
      flash[:success] = ["#{merchant.name} has been disabled"]
    end
    redirect_to '/merchants'
  end
end
