
class WorkersController < ApplicationController

  filter_resource_access :nested_in => :companies, :context => :users,
      :new => [:new, :create],
      :member => [:show, :edit, :update, :destroy],
      :collection => [:index]


  def index
    @workers = @company.users
  end

  def show
  end

  def new
    @user = @company.users.new
  end

  def create
    @user.role = Role::WORKER
    k = ActiveSupport::SecureRandom.hex(6)
    @user.password = k

    if @user.save
      flash[:notice] = t('company.flashes.worker_created')
      sendmail
      redirect_to company_workers_path
    else
      flash[:error] = t('company.flashes.worker_create_error')
      render :new
    end
  end

  def destroy
    @worker.destroy
    redirect_to company_workers_path
  end

  def load_company
    @company = current_user.company
  end

  def load_worker
    @worker = User.find(params[:id])
  end

  def sendmail
     UserMailer.welcome_email(@user).deliver
  #  email = @params["email"]
	#  recipient = email["recipient"]
	#  subject = email["subject"]
	#  message = email["message"]
  #  Emailer.deliver_contact(recipient, subject, message)
   end

  #def new_worker_for_collection
  #  @worker = @company.users.new
  #end

end
