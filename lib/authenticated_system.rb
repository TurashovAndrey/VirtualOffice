module AuthenticatedSystem
  def self.included m
    return unless m < ActionController::Base
    #m.filter_parameter_logging :password, :password_confirmation
    m.helper_method :current_user, :logged_in?
    m.prepend_before_filter :check_current_user, :set_current_user, :activate_authlogic
  end

  protected

  def set_current_user
    Authorization.current_user = (session = UserSession.find).try(:user)
  end

  def check_server_mode
    unless Features.server_mode?
      flash[:error] = t('user_session.flashes.application_not_in_server_mode')
      redirect_to root_path
    end
  end

  def check_enabled_subscriber_role
    unless Features::SubscriberRole.in_action?
      flash[:error] = t('user_session.flashes.subscriber_role_is_disabled')
      redirect_to root_path
    end
  end

  def check_enabled_payment_processor
    unless Features::PaymentProcessor.in_action?
      flash[:error] = t('user_session.flashes.payment_processor_is_disabled')
      redirect_to root_path
    end
  end

  def current_user
    Authorization.current_user
  end

  def logged_in?
    !current_user.instance_of?(Authorization::AnonymousUser)
  end

  def check_current_user
    unless logged_in?
      flash[:error] = t('user_session.flashes.please_login') unless store_location == root_path
      redirect_to new_user_session_path
    end
  end
  
  def permission_denied
    flash[:error] = t('user_session.flashes.access_denied')
    redirect_back_or_root
  end

  def redirect_back_or_default(default)
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to default
  end

  def redirect_back_or_root
    redirect_back_or_default root_path
  end

  def redirect_session_back_or_root
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

end