# coding: utf-8
class AccountsController < ApplicationController
  skip_before_filter :check_current_user, :only => [:new, :create, :activate]

  filter_resource_access :context => :users,
                         :new => [[:new, :new_account], [:create, :new_account]],
                         :member => [[:activate, :activate_account], [:show, :show_account], [:edit, :edit_account], [:update, :edit_account]],
                         :additional_member => [[:edit_password, :edit_password_account], [:update_password, :edit_password_account]]
  def new
  end

  def create
    @user.role = Role::MANAGER
    @user.active = true
    if @user.save
      flash[:notice] = t('user.flashes.created')
      redirect_to company_path
    else
      flash[:error] = t('user.flashes.create_error')
      render 'pages/main', :layout => 'main'
    end
  end

  def show
    @task = Task.new
    @projects = ProjectsHelper.get_projects(current_user)
    @themes = ThemesHelper.get_themes(current_user)

    @all_calendars = CalendarsHelper.get_calendars(current_user)
    @all_calendars += CalendarsHelper.get_private_calendars(current_user)

    @all_folders = FoldersHelper.get_folders(current_user)
    @all_folders += FoldersHelper.get_private_folders(current_user)

    @discussion = Discussion.new

    @event = Event.new
    @event.calendar = Calendar.find(current_user.company.calendar_id)

    @attachment = Attachment.new
  end

  def update
     @user.update_attributes(:first_name => params[:user][:first_name],
                             :last_name => params[:user][:last_name],
                             :telephone => params[:user][:telephone],
                             :address => params[:user][:address])

     if (!params[:set_chat].nil?)
       @user.update_attribute(:set_chat,true)
     else
       @user.update_attribute(:set_chat,false)
     end

     if (@user.update_attribute(:avatar, params[:user][:avatar]))
       flash[:notice] = "Данные пользователя успешно изменены"
     else
       flash[:error] = "Не удалось изменить данные пользователя"
     end

     if (params[:change_password])
       if (params[:user][:password] == params[:user][:password_confirmation])
         @user.update_attribute(:password,params[:user][:new_password])
         flash[:notice] = t('user.flashes.change_password')

         @user_session = UserSession.find
         @user_session.destroy

         redirect_to application_root_path
       else
         flash[:error] = t('user.flashes.change_password_error')
         redirect_to account_path
       end
     else
       redirect_to account_path
     end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)

    raise Exception if @user.active?

    if @user.activate!
      UserSession.create(@user, false)
      redirect_to account_url
    else
      render :action => :new
    end
  end

  protected

  def load_account
    @user = self.current_user
  end
end
