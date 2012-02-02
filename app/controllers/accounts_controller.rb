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
    if @user.save
      flash[:notice] = t('user.flashes.created')
      redirect_to account_path
    else
      flash[:error] = t('user.flashes.create_error')
      render 'pages/main', :layout => 'main'
    end
  end

  def show
  end

  def update
     @user.update_attribute(:first_name,params[:user][:first_name])
     @user.update_attribute(:last_name,params[:user][:last_name])
     @user.update_attribute(:avatar, params[:user][:avatar])

     redirect_to account_path
  end

  protected

  def load_account
    @user = self.current_user
  end

end
