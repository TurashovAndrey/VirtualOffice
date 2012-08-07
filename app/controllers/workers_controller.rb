
class WorkersController < ApplicationController

  filter_resource_access :nested_in => :companies, :context => :users,
      :new => [:new, :create],
      :member => [:show, :edit, :update, :destroy],
      :collection => [:index]


  def index

    if !params[:current_date].nil?
      @current_date = Date.parse(params[:current_date])
    else
      @current_date = Date.today
    end

    @workers = @company.users.find(:all, :conditions => ['email != ""'])
    @groups = Group.where(:company_id => @company.id).where(:parent_id => nil)
    @default_group = current_user.group
    @group = Group.new
    @user = User.new

    if !params[:task_number].nil?
      @task_number = params[:task_number].to_i
    else
      @task_number = 2
    end
    @tasks = get_group_tasks(current_user.group,@current_date,@task_number,false)

    if !params[:closed_task_number].nil?
      @closed_task_number = params[:closed_task_number].to_i
    else
      @closed_task_number = 2
    end

    @closed_tasks = get_group_tasks(current_user.group,@current_date, @closed_task_number,true)

    if !params[:event_number].nil?
      @event_number = params[:event_number].to_i
    else
      @event_number = 2
    end
    @events = get_group_events(current_user.group,@current_date,@event_number)

    if !params[:attachment_number].nil?
      @attachment_number = params[:attachment_number].to_i
    else
      @attachment_number = 10
    end
    @attachments = get_group_attachments(current_user.group, @current_date, @attachment_number)

    if !params[:discussion_number].nil?
      @discussion_number = params[:discussion_number].to_i
    else
      @discussion_number = 10
    end
    @discussions = get_group_discussions(current_user.group, @current_date, @discussion_number)


  end

  def show
    if !params[:current_date].nil?
      @current_date = Date.parse(params[:current_date])
    else
      @current_date = Date.today
    end

    @user = User.find(params[:id])
    @groups = Group.where(:company_id => @company.id).where(:parent_id => nil)

    if get_rights?(current_user, @user.group_id)
      if !params[:task_number].nil?
        @task_number = params[:task_number].to_i
      else
        @task_number = 2
      end

      @tasks = get_tasks(params[:id],@current_date, @task_number,false)

      if !params[:closed_task_number].nil?
        @closed_task_number = params[:closed_task_number].to_i
      else
        @closed_task_number = 2
      end

      @closed_tasks = get_tasks(params[:id],@current_date, @closed_task_number,true)

      if !params[:event_number].nil?
        @event_number = params[:event_number].to_i
      else
        @event_number = 2
      end
      @events = get_events(params[:id],@current_date,@event_number)

      if !params[:attachment_number].nil?
        @attachment_number = params[:attachment_number].to_i
      else
        @attachment_number = 10
      end
      @attachments = get_attachments(params[:id], @current_date, @attachment_number)

      if !params[:discussion_number].nil?
        @discussion_number = params[:discussion_number].to_i
      else
        @discussion_number = 10
      end
      @discussions = get_discussions(params[:id], @current_date, @discussion_number)
    end
  end

  def new
    @user = @company.users.new
  end

  def create
    @user.role = Role::WORKER
    k = ActiveSupport::SecureRandom.hex(6)
    @user.password = k.to_s

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
  end

  protected

  def get_tasks(user_id,date,limit_value,done)
      @ltasks = []
      @user = User.find(user_id)
      if done == false
        if limit_value>0
          @user_tasks = Task.where(:user_id=>@user).where('Date(created_at) = ?', date).where(:done=>done).limit(limit_value)
        else
          @user_tasks = Task.where(:user_id=>@user).where('Date(created_at) = ?', date).where(:done=>done).all
        end
      else
        if limit_value>0
          @user_tasks = Task.where(:user_id=>@user).where('Date(updated_at) = ?', date).where(:done=>done).limit(limit_value)
        else
          @user_tasks = Task.where(:user_id=>@user).where('Date(updated_at) = ?', date).where(:done=>done).all
        end
      end

      if !@user_tasks.empty?
        @user_tasks.each do |user_task|
          @ltasks<<Task.find(user_task)
        end
      end
      @ltasks
  end

  def get_events(user_id,date,limit_value)
    @events = []
    @user = User.find(user_id)
    if limit_value>0
      @user_events = Event.where(:user_id=>@user).where('Date(created_at) = ?', date).limit(limit_value)
    else
      @user_events = Event.where(:user_id=>@user).where('Date(created_at) = ?', date).all
    end
    if !@user_events.empty?
      @user_events.each do |user_event|
        @events<<Event.find(user_event)
      end
    end
    @events
  end

  def get_group_tasks(group_id,date,limit_value,done)
    @current_group = Group.find(group_id)
    @ltasks = []

    @current_group.users.each do |user|
      if done == false
        @user_tasks = Task.where(:user_id=>user).where('Date(created_at) = ?', date).where(:done=>done).all
      else
        @user_tasks = Task.where(:user_id=>user).where('Date(updated_at) = ?', date).where(:done=>done).all
      end

      if !@user_tasks.empty?
        @user_tasks.each do |user_task|
          if limit_value>0
            if @ltasks.count < limit_value
              @ltasks<<Task.find(user_task)
            end
          else
            @ltasks<<Task.find(user_task)
          end
        end
      end
    end
    @ltasks
  end

  def get_group_events(group_id,date,limit_value)
    @current_group = Group.find(group_id)
    @events = []

    @current_group.users.each do |user|
      @user_events = Event.where(:user_id=>user).where('Date(created_at) = ?', date).all
      if !@user_events.empty?
        @user_events.each do |user_event|
          if limit_value>0
            if @events.count < limit_value
              @events<<Event.find(user_event)
            end
          else
            @events<<Event.find(user_event)
          end
        end
      end
    end
    @events
  end

  def get_group_attachments(group_id,date, limit_value)
    @current_group = Group.find(group_id)
    @lattachments = []

    @current_group.users.each do |user|
      @user_attachments = Attachment.where(:user_id=>user).where('Date(created_at) = ?', date).all
      if !@user_attachments.empty?
        @user_attachments.each do |user_attachment|
          if limit_value>0
            if @lattachments.count < limit_value
              @lattachments<<Attachment.find(user_attachment)
            end
          else
            @lattachments<<Attachment.find(user_attachment)
          end
        end
      end
    end
    @lattachments
  end

  def get_attachments(user_id,date,limit_value)
    @current_user = User.find(user_id)
    @lattachments = []

    if limit_value>0
      @user_attachments = Attachment.where(:user_id=>@user).where('Date(created_at) = ?', date).limit(limit_value)
    else
      @user_attachments = Attachment.where(:user_id=>@user).where('Date(created_at) = ?', date).all
    end
    if !@user_attachments.empty?
      @user_attachments.each do |user_attachment|
        @lattachments<<Attachment.find(user_attachment)
      end
    end
    @lattachments
  end

  def get_discussions(user_id,date,limit_value)
    @discussions = []
    @user = User.find(user_id)
    if limit_value>0
      @user_discussions = Discussion.where(:user_id=>@user).where('Date(created_at) = ?', date).limit(limit_value)
    else
      @user_discussions = Discussion.where(:user_id=>@user).where('Date(created_at) = ?', date).all
    end
    if !@user_discussions.empty?
      @user_discussions.each do |user_discussion|
        @discussions<<Discussion.find(user_discussion)
      end
    end
    @discussions
  end

  def get_group_discussions(group_id,date,limit_value)
    @current_group = Group.find(group_id)
    @discussions = []

    @current_group.users.each do |user|
      @user_discussions = Discussion.where(:user_id=>user).where('Date(created_at) = ?', date).all
      if !@user_discussions.empty?
        @user_discussions.each do |user_discussion|
          if limit_value>0
            if @discussions.count < limit_value
              @discussions<<Discussion.find(user_discussion)
            end
          else
            @discussions<<Discussion.find(user_event)
          end
        end
      end
    end
    @discussions
  end

  def get_rights?(user, group_id)
    if user.group_id == group_id
      @get_rights = true
    else
      @user_group = Group.find(user.group_id)
      @get_rights = false
      @child_groups = Group.where(:parent_id=>@user_group)

      @child_groups.each do |group|
        if group.id == group_id
          @get_rights = true
        else
           @child_child_groups = Group.where(:parent_id=>group)
           @child_child_groups.each do |child_group|
             if child_group.id == group_id
               @get_rights = true
             end
           end
        end
      end
    end
    @get_rights
  end


end
