class SessionsController < ApplicationController
  before_action :load_user_from_params, only: :create

  def new; end

  def create
    if @user&.authenticate(params.dig(:session, :password))
      reset_session
      log_in @user
      params.dig(:session, :remember_me) == "1" ? remember(@user) : forget(@user)
      redirect_to @user
      # Log the user in and redirect to the user's show page.
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
  def load_user_from_params
    @user = User.find_by email: params.dig(:session, :email)&.downcase
  end
end
