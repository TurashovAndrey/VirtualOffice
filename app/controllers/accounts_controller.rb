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
      flash[:notice] = 'User was successfully created.'
      redirect_to account_path
    else
      render :action => "new"
    end
  end

  def show
  end

  protected

  def load_account
    @user = self.current_user
  end

end
