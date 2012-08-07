class GroupsController < ApplicationController
  def new
    @group = Group.new
    @group.parent_id = params[:parent_id]
    @group.company = current_user.company

    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)
  end

  def create
    if (Group.find(params[:group][:parent_id]).parent_id.nil?) ||
       (Group.find(Group.find(params[:group][:parent_id]).parent_id).parent_id.nil?)
      @group = Group.new
      @group.company = current_user.company
      @group.update_attributes(params[:group])
    end
    redirect_to company_workers_path
  end

  def show
    if !params[:current_date].nil?
      @current_date = Date.parse(params[:current_date])
    else
      @current_date = Date.today
    end

    @group = Group.find(params[:id])
    @groups = Group.where(:company_id => current_user.company.id).where(:parent_id => nil)

    if get_rights?(current_user, @group.id)
      if !params[:task_number].nil?
        @task_number = params[:task_number].to_i
      else
        @task_number = 2
      end
      @tasks = get_tasks(@group.id, @current_date, @task_number,false)

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
      @events = get_events(@group.id, @current_date, @event_number)

      if !params[:attachment_number].nil?
        @attachment_number = params[:attachment_number].to_i
      else
        @attachment_number = 10
      end
      @attachments = get_attachments(@group.id, @current_date, @attachment_number)

      if !params[:discussion_number].nil?
        @discussion_number = params[:discussion_number].to_i
      else
        @discussion_number = 2
      end
      @discussions = get_discussions(@group.id, @current_date, @discussion_number)

    end
  end

  protected

  def get_tasks(group_id,date,limit_value,done)
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

  def get_events(group_id,date, limit_value)
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

  def get_attachments(group_id,date, limit_value)
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

  def get_discussions(group_id,date,limit_value)
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
