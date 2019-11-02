class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = ["Congratulations #{@user.name}, you have registered and are now logged in!"]
      session[:user_id] = @user.id
      redirect_to '/profile'
    else
      flash.now[:error] = @user.errors.full_messages.uniq
      render :new
    end
  end

  def show
    if current_user
      @user = current_user
    else
      render_404
    end
  end

  def edit
    if current_user
      @info = params[:info]
    else
      render_404
    end
  end

  def update
    user = current_user
    @info = params[:info]

    if !@info && user.update(user_params)
      flash[:success] = ['You have succesfully updated your information!']
      redirect_to '/profile'
    elsif !@info && !user.update(user_params)
      flash.now[:error] = user.errors.full_messages
      render :edit
    elsif @info == 'false'
      if params[:password].blank? || params[:password_confirmation].blank?
        flash.now[:error] = ['Please fill in both password fields']
        render :edit
      elsif params[:password] != params[:password_confirmation]
        flash.now[:error] = ['Password confirmation doesn\'t match Password']
        render :edit
      elsif user.update(user_params)
        flash[:success] = ['You have successfully updated your password!']
        redirect_to '/profile'
      end
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
