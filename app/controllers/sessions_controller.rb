class SessionsController < ApplicationController
  def new
    @user = User.new
    if current_user
      flash[:error] = ['Sorry, you are already logged in.']
      redirect(current_user)
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = ["#{user.name}, you have successfully logged in."]
      redirect(user)
    else
      @user = User.new(email: params[:email])
      flash[:error] = ["Sorry, credentials were invalid. Please try again."]
      render :new
    end
  end

  def destroy
    user = current_user
    reset_session
    flash[:success] = ["#{user.name}, you have logged out!"]
    redirect_to '/'
  end

  private

  def redirect(user)
    redirect_to '/profile' if user.default?
    redirect_to '/merchant' if user.merchant_employee? || user.merchant_admin?
    redirect_to '/admin' if user.admin?
  end
end
