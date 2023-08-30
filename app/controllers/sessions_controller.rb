class SessionsController < ApplicationController
  before_action :load_user_from_params, only: :create

  def new; end

  def create
    if @user&.authenticate(params.dig(:session, :password))
      user_activated
    else
      # Create an error message.
      flash[:danger] = t("login.fail")
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
  def user_activated user
    if @user.activated?
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      message = t("user.activation.not_active_message")
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def load_user_from_params
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return unless @user.nil?

    flash[:danger] = t("login.fail")
    render "new", status: :unprocessable_entity
  end
end
