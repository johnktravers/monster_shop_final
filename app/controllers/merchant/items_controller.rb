class Merchant::ItemsController < Merchant::BaseController
  before_action :require_merchant_admin, except: [:index]

  def index
    @merchant = current_user.merchant
  end

  def update
    @item = Item.find(params[:id])
    if request.query_string == 'toggle_status'
      @item.toggle! :active?
      if @item.active?
        flash[:success] = ["#{@item.name} is now for sale"]
      else
        flash[:error] = ["#{@item.name} is no longer for sale"]
      end
      redirect_to '/merchant/items'
    else
      @item.update(item_params)
      if params[:image] == ''
        @item.update(image: 'https://i.ytimg.com/vi/Xw1C5T-fH2Y/maxresdefault.jpg')
      end
      if @item.save
        flash[:success] = ["#{@item.name} has been successfully updated"]
        redirect_to '/merchant/items'
      else
        flash.now[:error] = @item.errors.full_messages
        render :edit
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = ["#{item.name} has been successfully deleted"]
    redirect_to '/merchant/items'
  end

  def new
    @merchant = current_user.merchant
    @item = Item.new(image: nil)
  end

  def create
    @merchant = current_user.merchant
    @item = @merchant.items.create(item_params)
    if params[:image] == ''
      @item.update(image: 'https://i.ytimg.com/vi/Xw1C5T-fH2Y/maxresdefault.jpg')
    end
    if @item.save
      flash[:success] = ["#{@item.name} has been successfully created"]
      redirect_to '/merchant/items'
    else
      flash.now[:error] = @item.errors.full_messages
      render :new
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end

  def require_merchant_admin
    render_404 unless current_user.merchant_admin?
  end
end
