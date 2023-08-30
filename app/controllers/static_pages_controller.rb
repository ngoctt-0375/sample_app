class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build if logged_in?
    @pagy, @feed_items = pagy current_user.feed,
                              item: Settings.micro_post.limit_items
  end

  def help; end

  def about; end
end
