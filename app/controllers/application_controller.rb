class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include ChessStoreHelpers::Cart
  before_action :count_cart_items
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You do not have access to this page."
    redirect_to home_path
  end  

  private 
  #Handling authentication

  def count_cart_items
    @cart_items = []
    unless session[:cart].nil?
      @cart_items = get_list_of_items_in_cart
    end
    @cart_items
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

end
