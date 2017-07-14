class SessionsController < ApplicationController
  def new
  end

  def create
    Rails.logger.debug("My object: #{params[:username]}")
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "Logged in!" }
        format.json { render json:  "{\"notice\":\"Logged in!\"}" }
      end
    else
      flash.now.alert = "Invalid username or password!"
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: flash.to_hash}
      end
    end
  end

  def destroy
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to root_url, :notice => "Logged out!" }
      format.json { render json:  "{\"notice\":\"Logged out!\"}" }
    end
  end
end
