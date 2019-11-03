class UserAddressesController < ApplicationController
  before_action :require_user

  def edit
    @address = current_user.addresses.find_by(id: params[:id])
    render_404 unless @address
  end


  private

  def require_user
    render_404 unless current_user
  end
end
