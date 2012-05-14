class UserSessionsController < ApplicationController
  filter_resource_access
  skip_before_filter :check_current_user, :only => [:new, :create, :activate, :create_demo]

  def new
    if logged_in?
      redirect_session_back_or_root
    else
      render :action => :new, :layout => 'main'
    end
  end

  def create_demo
   @user_session = UserSession.new
   @user_session.email = "test@test.com"
   @user_session.password = "test"

   if @user_session.save
      new_user = @user_session.record
      Authorization.current_user = new_user
      redirect_to application_root_path(current_user.company.url_base)
   else
      flash[:notice] = t('user_session.flashes.login_failed')
      render :action => :new, :layout => "main"
   end
  end

  def create
    if (logged_in?)
      redirect_session_back_or_root
    elsif @user_session.save
      new_user = @user_session.record
      Authorization.current_user = new_user

      # flash[:notice] = t('user_session.flashes.logged_in')

      redirect_to application_root_path(current_user.company.url_base)
    else
      flash[:notice] = t('user_session.flashes.login_failed')
      render :action => :new, :layout => "main"
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    flash[:notice] = t('user_session.flashes.logged_out')
    redirect_to application_root_path
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    if (@user)
      @user.active = true
      @user.save
    end
    redirect_to application_root_path
  end

  protected

  def new_user_session
    @user_session = UserSession.new(params[:user_session])
  end

  def load_user_session
    @user_session = UserSession.find
  end
end
