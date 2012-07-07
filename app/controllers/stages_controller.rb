class StagesController < ApplicationController
  def new
    @stage = Stage.new
    if (!params[:project_id].nil?)
      @project = Project.find(params[:project_id])
    end
    @projects = current_user.projects
    @stage.project = @project
    @comment = Comment.new
    @comment.user = current_user
    @task_attachment = TaskAttachment.new
  end

  def create
    @stage = Stage.new
    if (params[:stage][:project_id]!="")
      @project = Project.find(params[:stage][:project_id])
      @stage.project = @project
    end
    @stage.update_attributes(params[:stage])
    if (@project.nil?)
      redirect_to tasks_path
    else
      redirect_to project_path(@project)
    end
  end

  def show
    @stage = Stage.find(params[:id])
    @project = Project.find(@stage.project_id)
    @tasks = Task.where(:stage_id => @stage)
    @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:stage_id => @stage)
  end
end
