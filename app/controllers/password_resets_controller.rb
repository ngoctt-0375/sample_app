class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("user.password_reset.info")
      redirect_to root_url
    else
      flash.now[:danger] = t("user.password_reset.email_not_found")
      render "new"
    end
  end

  def update
    if params.dig(:user, :password).empty?
      @user.errors.add :password,
                       t("user.password_reset.warning_empty_password")
      render "edit"
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t("user.password_reset.success")
      redirect_to @user
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("user.edit.not_found")
    redirect_to root_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("user.not_active")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("user.password_reset.token_expired")
    redirect_to new_password_reset_url
  end
end
