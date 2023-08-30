class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params

    @micropost.image.attach(params.dig(:micropost, :image))
    flash[:success] = if @micropost.save
                        t("micro_post.created").capitalize
                      else
                        t("micro_post.created_fail").capitalize
                      end

    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("micro_post.deleted").capitalize
    else
      flash[:danger] = t("micro_post.deleted_fail").capitalize
    end
    redirect_to ( request.referer || root_path), status: :see_other
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("micro_post.invalid").capitalize
    redirect_to ( request.referer || root_path), status: :see_other
  end
end
