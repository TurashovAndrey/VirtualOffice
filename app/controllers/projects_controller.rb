class ProjectsController < ApplicationController

  def new
    redirect_to projects_path
  end

  def create
    @project = Project.new
    @project.user = current_user
    @project.company = current_user.company
    if @project.update_attributes(params[:project])
      flash[:notice] = t('project.save.success')
      redirect_to project_path(@project)
    else
      flash[:error] = t('project.save.error')
    end
  end

  def index
    get_init_projects
    @new_project = Project.new
    unless current_user.company.projects.first.nil?
      @project = current_user.company.projects.first
    end
  end

  def show
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_url, :error => t('project.flash.has_no_permission_to_show')
  else
    get_init_projects
    @new_project = Project.new
    @new_task = Task.new
    @new_task.project = @project
    unless has_permission_to_project? params[:id]
      redirect_to projects_path, :error => t('project.flash.has_no_permission_to_show')
    end
  end

  def edit
    @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url, :error => t('project.flash.has_no_permission_to_show')
    else
      if has_permission_to_project? params[:id]
        get_init_projects
      else
        flash[:error] = t('project.flash.has_no_permission_to_edit')
      end
  end

  def update
    @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url, :error => t('project.flash.has_no_permission_to_show')
    else
      if has_permission_to_project? params[:id]
        if @project.update_attributes(params[:project])
          flash[:notice] = t('project.save.success')
          redirect_to project_path(@project)
        else
          flash[:error] = t('project.save.error')
          redirect_to projects_path
        end
      else
        flash[:error] = t('project.flash.has_no_permission_to_edit')
        redirect_to projects_path
      end
  end

  def destroy
    @project = Project.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url, :error => t('project.flash.has_no_permission_to_show')
    else
      if has_permission_to_project?(params[:id])
        @project = Project.find(params[:id])
        @project.destroy
      else
        flash[:error] = t('project.flash.has_no_permission_to_delete')
      end
      redirect_to projects_path
  end

  protected

  def has_permission_to_project?(project_id)
    (Project.find(project_id).company == current_user.company) or
        (Project.find(project_id).user == current_user)
  end

  def get_init_projects
    @company_projects = current_user.company.projects
  end

end
