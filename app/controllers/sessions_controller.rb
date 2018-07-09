class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      activate user
    else
      flash.now[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def params_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  private

  def activate user
    if user.activated?
      log_in user
      params_remember user
      redirect_back_or user
    else
      message  = t ".account"
      message += t ".check"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
