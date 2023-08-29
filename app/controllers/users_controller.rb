class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(update edit)
  before_action :find_user, only: %i(show update edit destroy)
  before_action :correct_user, only: %i(update edit)
  before_action :admin_user, only: :destroy

  def show; end

  def index
    @pagy, @users = pagy User.all, items: Settings.page_30
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t("sign_up.create.success")
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("user.update.success")
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user.destroy.success")
    else
      flash[:danger] = t("user.destroy.fail")
    end
    redirect_to users_url
  end

  private
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("login.not_login")
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("login.edit.not_found")
    store_location
    redirect_to login_url, status: :see_other
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("user.not_correct_user")
    redirect_to root_path
  end
end
