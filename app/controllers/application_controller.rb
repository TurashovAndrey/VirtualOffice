class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem

  before_filter :current_path, :check_subdomain

  def current_path
    @current_path ||= request.env['PATH_INFO']
  end

  def application_root_path(subdomain = nil)
    path = request.protocol
    path += current_user.company.url_base + "." if subdomain
    path += request.subdomains.empty? ? request.env['HTTP_HOST'] : request.env['HTTP_HOST'].gsub(request.subdomains.first + ".", '')
    path
  end

  private

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def check_subdomain
    if logged_in? && !request.subdomains.empty?
      unless current_user.company.url_base == request.subdomains.first
        flash[:error] = t('user_session.flashes.access_denied')
        redirect_to application_root_path(current_user.company.url_base)
      end
    end
  end
end
