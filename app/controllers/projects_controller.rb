class ProjectsController < ApplicationController

  def new
    @project = Project.new
    @projects = current_user.projects

    @comment = Comment.new
    @comment.user = current_user
    @comment.project = @project

    @task_attachment = TaskAttachment.new
  end

  def create
    @projects = current_user.projects
    @project = Project.new

    @project.company = current_user.company
    @project.user = current_user
    @project.update_attributes(params[:project])
    redirect_to project_path(@project)
  end

  def index
    @tasks = Task.where(:user_id => current_user).where(:project_id => nil).where(:done => 0)
    @projects = Project.where(:company_id => current_user.company)
    @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:project_id => nil);
  end

  def show
    @project = Project.find(params[:id])
    @stages = Stage.where(:project_id => @project.id)

    if (!@project.nil?)
      @tasks = Task.where(:project_id => @project).where(:done => 0)
    else
      @tasks = Task.where(:user_id => current_user).where(:done => 0)
    end
    @projects = Project.where(:company_id => current_user.company)
    @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:project_id => @project)
  end

  def update
    @project.update_attributes(params[:project])
  end

end
