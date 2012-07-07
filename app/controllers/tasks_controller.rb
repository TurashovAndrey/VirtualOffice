class TasksController < ApplicationController

  def edit
    @task = Task.find(params[:id])
    @comment = Comment.new
    @comment.user = current_user
    @task_attachment = TaskAttachment.new
    @projects = current_user.projects
  end

  def index
    @tasks = Task.where(:user_id => current_user).where(:done => 0)
    @task = Task.new

    @projects = Project.where(:company_id => current_user.company)
  end

  def create
    @task = Task.new
    @task.user = current_user
    @task.company = current_user.company

    @permissions = []

    #Добавить парсилку по группам
    if !params[:task][:group_id].empty?
      @groups = params[:task][:group_id]
      @groups.each do |new_group|
        @new_permission = Permission.new
        @new_permission.task_id = @task
        @new_permission.company = current_user.company
        @new_permission.group = Group.find(new_group)
        @new_permission.save
      end
    end

    @permission = Permission.new
    @permission.description = "New task has been created"
    @permission.task = @task
    @permission.user = current_user
    @permission.company = current_user.company

    if (!params[:task].nil? && params[:task][:project_id]!="")
      @task.project = Project.find(params[:task][:project_id])
      if (params[:task][:stage_id]!="")
        @task.stage = Stage.find(params[:task][:stage_id])
        @task.update_attributes(params[:task])
        redirect_to stage_path(@task.stage)
      else
        @task.update_attributes(params[:task])
        @permission.save
        redirect_to project_path(@task.project)
      end
    else
      @task.update_attributes(params[:task])
      @permission.save
      redirect_to projects_path
    end
  end

  def new
    @task = Task.new
    if (!params[:project_id].nil?)
      @project = Project.find(params[:project_id])
    end

    if (!params[:stage_id].nil?)
      @stage = Stage.find(params[:stage_id])
      @project = Project.find(@stage.project_id)
    end

    @task.stage = @stage
    @task.project = @project
    @comment = Comment.new
    @comment.user = current_user
    @task_attachment = TaskAttachment.new
    @projects = current_user.projects
  end

  def show
    @task = Task.find(params[:id])

    @projects = current_user.projects
    @stage = @task.stage
    @project = @task.project

    @comments = Comment.where(:task_id => @task)
    @comment = Comment.new
    @comment.user = current_user

    @task_attachment = TaskAttachment.new
    @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:task_id => @task)
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    if !((params[:comment][:comment] == "") && (params[:task_attachment].nil?))
      #Save comment and attachment for it
      @comment = Comment.new
      @comment.task = Task.find(params[:id])
      @comment.user = current_user
      @comment.company = current_user.company
      @comment.comment = params[:comment][:comment]
      @comment.comment_date = DateTime.now
      @comment.save

      if !(params[:task_attachment].nil?)
        @attachment = TaskAttachment.new
        @attachment.task = Task.find(params[:id])
        @attachment.user = current_user
        @attachment.company = current_user.company
        @attachment.comment = @comment
        @attachment.attachment =  params[:task_attachment][:attachment]
        @attachment.save
      end
    end
    redirect_to task_path(@task)
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    if (!params[:project_id].nil?)
      redirect_to project_path(Project.find(params[:project_id]))
    end

    if (!params[:stage_id].nil?)
      redirect_to stage_path(Stage.find(params[:stage_id]))
    end

    redirect_to projects_path
  end

  protected
  def load_task
    @task = Task.new
  end

end
