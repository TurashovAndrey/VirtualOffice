class UserSessionsController < ApplicationController
  filter_resource_access
  skip_before_filter :check_current_user, :only => [:new, :create]
 
  def new
  end

  def create
    if logged_in?
      redirect_session_back_or_root
    elsif @user_session.save
      new_user = @user_session.record
      Authorization.current_user = new_user

      flash[:notice] = t('user_session.flashes.logged_in')
      redirect_to
    else
      render :action => :new, :layout => "login"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end

  protected

  def new_user_session
    @user_session = UserSession.new(params[:user_session])
  end

  def load_user_session
    @user_session = UserSession.find
  end
end
