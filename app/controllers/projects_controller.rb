class ProjectsController < ApplicationController

  def new
    @project = Project.new
    @projects = ProjectsHelper.get_projects(current_user)
    @change_project_name = true
  end

  def create
    @projects = ProjectsHelper.get_projects(current_user)
    if (params[:project][:project_name].empty?)
      redirect_to new_project_path
    else
      @project = Project.new
      @project.company = current_user.company
      @project.user = current_user
      @project.update_attributes(params[:project])

      save_groups(params[:group_ids],@project)
      redirect_to projects_path
    end
  end

  def index
    @tasks = Task.where(:user_id => current_user).where(:project_id => nil).where(:done => 0)
    @projects = ProjectsHelper.get_projects(current_user)
    @change_project_name = true
    @project = Project.new
    @task = Task.new
    @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:project_id => nil)
  end

  def show
    @project = get_project_permissions(params[:id])
    @change_project_name = true
    @stage = Stage.new
    @task = Task.new
    if @project.nil?
      redirect_to projects_path
    else
      @projects = ProjectsHelper.get_projects(current_user)
      @stages = ProjectsHelper.get_stages(@project.id,current_user)
      @tasks = Task.where(:second_user_id => current_user).where(:project_id => params[:id]).where(:done => 0)
      @task_attachments = []
      #@task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:project_id => @project)
    end
  end

  def edit
    @project = get_project_permissions(params[:id])
    @change_project_name = true
    if @project.nil?
      redirect_to projects_path
    else
      @projects = ProjectsHelper.get_projects(current_user)
    end
  end

  def update
    @project = get_project_permissions(params[:id])
    if @project.nil?
      redirect_to projects_path
    else
      @project.update_attributes(params[:project])
      if (!params[:group_ids].nil?)
        save_groups(params[:group_ids],@project)
      end
      respond_to do |format|
        format.html  {redirect_to project_path(@project)}
        #format.html { redirect_to(@calendar, :notice => 'User was successfully updated.') }
        #format.json do
        #  render :nothing => true, :status => :ok
        #  return true
        #end
        format.json { render :json => @project, :status => :ok }
      end

      #redirect_to project_path(@project)
    end
  end

  def destroy
    @project = get_project_permissions(params[:id])
    if @project.nil?
      redirect_to projects_path
    else
      Permission.delete_all(:project_id => @project)
      @project.destroy
      redirect_to projects_path
    end
  end

  protected

  def get_project_permissions(project_id)
    @project = nil
    @project_perms = Permission.where(:company_id => current_user.company).where(:project_id => project_id).order(:group_id)
    @project_perms.each do |project_perm|
      if ((project_perm.user == current_user) ||
         ((project_perm.group == current_user.group) && (project_perm.company == current_user.company)) ||
         ((project_perm.group.nil?) && (project_perm.user.nil?) && (project_perm.company == current_user.company)))
        @project = Project.find(project_id)
        @permissions = Permission.where(:project_id => @project)
      end
    end
    @project
  end

  def need_saving?(new_group, project_id)
    @need_to_save = true
    if (new_group.nil?)
      if (!Permission.where(:user_id => current_user).where(:project_id => project_id).empty?)
        @need_to_save = false
      end
    else
      if (new_group.to_i == 0)
        if (!Permission.where(:company_id => current_user.company).where(:project_id => project_id).empty?)
          @need_to_save = false
        end
      else
        if (!Permission.where(:group_id => new_group).where(:project_id => project_id).empty?)
          @need_to_save = false
        end
      end
    end
    @need_to_save
  end

  def save_groups(groups, project)
    @need_save = true
    Permission.delete_all(:project_id => project)
    if (groups.nil?)
      if (need_saving?(nil,project.id))
        @new_permission = Permission.new
        @new_permission.project = project
        @new_permission.company = current_user.company
        @new_permission.user = current_user
        @new_permission.save
      end
    else
      groups.each do |new_group|
        while (!new_group.nil?) && (@need_save)
          if need_saving?(new_group,project.id)
            @new_permission = Permission.new
            @new_permission.project = project
            @new_permission.company = current_user.company
            if (new_group.to_i != 0)
              @new_permission.group = Group.find(new_group)
            end
            @new_permission.save
          end
          if (new_group.to_i != 0)
            new_group = Group.find(new_group).parent_id
          else
            @need_save = false
          end
        end
      end
    end
  end
end
