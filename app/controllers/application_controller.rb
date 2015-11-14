class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  def current_user
    @current_user ||= Member.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    render nothing: true, status: 401 if current_user.nil?
  end
end
