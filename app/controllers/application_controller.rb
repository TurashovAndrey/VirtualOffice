class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem

  before_filter :current_path

  def current_path
    @current_path ||= request.env['PATH_INFO']
  end

  private

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
