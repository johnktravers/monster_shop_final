class UserAddressesController < ApplicationController
  before_action :require_user

  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      flash[:success] = ['You have successfully added a new address!']
      redirect_to '/profile'
    else
      flash[:error] = @address.errors.full_messages
      render :new
    end
  end

  def edit
    @address = current_user.addresses.find_by(id: params[:id])
    render_404 unless @address
  end

  def update
    address = current_user.addresses.find_by(id: params[:id])
    if address && address.update(address_params)
      flash[:success] = ['Your address has been successfully updated!']
      redirect_to '/profile'
    else
      flash[:error] = address.errors.full_messages
      @address = Address.new(address_params)
      render :edit
    end
  end

  def destroy
    address = current_user.addresses.find_by(id: params[:id])
    if address && address.orders.empty?
      address.destroy
      flash[:success] = ['Your address has been successfully deleted!']
      redirect_to '/profile'
    end
  end


  private

  def require_user
    render_404 unless current_user
  end

  def address_params
    params.permit(:nickname, :address, :city, :state, :zip)
  end
end
