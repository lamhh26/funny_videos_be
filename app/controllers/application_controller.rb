class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  include ErrorHandler

  protect_from_forgery with: :exception

  after_action :set_csrf_cookie

  private

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token
  end
end
