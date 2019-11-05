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
      flash[:error] = @coupon.errors.full_messages
      render :new
    end
  end


  private

  def coupon_params
    params.permit(:name, :percent_off, :dollar_off)
  end
end
