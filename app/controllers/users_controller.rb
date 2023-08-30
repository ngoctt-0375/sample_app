class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(show update edit following followers)
  before_action :find_user,
                only: %i(show update edit destroy following followers)
  before_action :correct_user, only: %i(update edit)
  before_action :admin_user, only: :destroy

  def show
    @pagy, @microposts = pagy @user.microposts.all, items: Settings.page_10
  end

  def index
    @pagy, @users = pagy User.all, items: Settings.page_30
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t("user.activation.check_email_message")
      redirect_to login_url
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

  def following
    @title = t("relationship.following.title")
    @pagy, @users = pagy @user.following,
                         item: Settings.micro_post.limit_items
    render "show_follow", status: :unprocessable_entity
  end

  def followers
    @title = t("relationship.follower.title")
    @pagy, @users = pagy @user.followers,
                         item: Settings.micro_post.limit_items
    render "show_follow", status: :unprocessable_entity
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

  def correct_user
    return if current_user? @user

    flash[:danger] = t("user.not_correct_user")
    redirect_to root_path
  end
end
