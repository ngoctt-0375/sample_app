class ApplicationController < ActionController::Base
  before_action :set_locale

  include Pagy::Backend
  include SessionsHelper
  include Pagy::Backend
  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("login.not_login")
    store_location
    redirect_to login_url, status: :see_other
  end
end
