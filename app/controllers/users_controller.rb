class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :surname, :username, :email, :password, :password_confirmation]

  def current_user_profile
    @user = current_user
    if @user
      render 'show'
    else
      render 'sessions/new'
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @user, :except => :password_digest}
    end
  end

  def new
    @user = User.new
  end

  def edit
    if session[:user_id] != params[:id]
      redirect_to root_url, :notice => "Unauthorized access!"
    end
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      render action: 'show'
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:password])
      if @user.update(user_params)
        session[:user_id] = @user.id
        redirect_to @user, :notice => "Account updated!"
      else
        render 'edit'
      end
    else
      flash.now.alert = "Invalid username or password!"
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :surname, :username, :email, :password, :password_confirmation)
  end
end
