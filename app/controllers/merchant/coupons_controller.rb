class Merchant::CouponsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @merchant = current_user.merchant
    @coupon = Coupon.new
  end

  def create
    @merchant = current_user.merchant
    @coupon = @merchant.coupons.new(coupon_params)
    if @coupon.save
      flash[:success] = ["You have successfully created a #{@coupon.name} coupon!"]
      redirect_to '/merchant/coupons'
    else
      flash.now[:error] = @coupon.errors.full_messages
      render :new
    end
  end

  def edit
    @merchant = current_user.merchant
    @coupon = @merchant.coupons.find_by(id: params[:id])
    render_404 unless @coupon
  end

  def update
    @merchant = current_user.merchant
    @coupon = @merchant.coupons.find_by(id: params[:id])
    if @coupon.update(coupon_params)
      flash[:success] = ["You have successfully updated your #{@coupon.name} coupon!"]
      redirect_to '/merchant/coupons'
    else
      flash.now[:error] = @coupon.errors.full_messages
      render :edit
    end
  end

  def destroy
    merchant = current_user.merchant
    coupon = merchant.coupons.find_by(id: params[:id])
    coupon.destroy
    flash[:success] = ["You have successfully deleted your #{coupon.name} coupon!"]
    redirect_to '/merchant/coupons'
  end


  private

  def coupon_params
    params.permit(:name, :percent_off, :dollar_off)
  end
end
