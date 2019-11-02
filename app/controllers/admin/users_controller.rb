class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    users = User.where(id: params[:id])
    if users.empty?
      render_404
    else
      @user = users.first
    end
  end
end
