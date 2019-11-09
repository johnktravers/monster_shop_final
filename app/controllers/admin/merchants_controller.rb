class Admin::MerchantsController < Admin::BaseController
  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      redirect_to "/admin/merchants/#{@merchant.id}"
    else
      flash.now[:error] = @merchant.errors.full_messages
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:id])
    merchant.destroy
    flash[:success] = ["You have successfully deleted #{merchant.name}"]
    redirect_to merchants_path
  end

  def update
    @merchant = Merchant.find(params[:id])

    if params[:toggle]
      @merchant.toggle! :enabled?
      @merchant.items.each do |item|
        item.update(active?: @merchant.enabled?)
      end
      if @merchant.enabled?
        flash[:success] = ["#{@merchant.name} has been enabled"]
      else
        flash[:success] = ["#{@merchant.name} has been disabled"]
      end
      redirect_to merchants_path
    else
      @merchant.update(merchant_params)
      if @merchant.save
        redirect_to "/admin/merchants/#{@merchant.id}"
      else
        flash.now[:error] = @merchant.errors.full_messages
        render :edit
      end
    end
  end


  private

  def merchant_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
