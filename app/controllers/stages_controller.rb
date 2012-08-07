class StagesController < ApplicationController
  def new
    @stage = Stage.new
    @projects = get_projects
    @comment = Comment.new
    @comment.user = current_user
    @task_attachment = TaskAttachment.new
    if (!params[:project_id].nil?)
      @project = get_project_permissions(params[:project_id])
      if @project.nil?
        redirect_to projects_path
      else
        @stage.project = @project
      end
    end
  end

  def create
    @stage = Stage.new
    @project = get_project_permissions(params[:stage][:project_id])
    if @project.nil?
       redirect_to projects_path
    else
      @stage.project = @project
      @stage.update_attributes(params[:stage])
      save_groups(params[:group_ids],@stage)
      if (@project.nil?)
        redirect_to tasks_path
      else
        redirect_to project_path(@project)
      end
    end
  end

  def show
    @stage = get_stage_permissions(params[:id])
    if @stage.nil?
      redirect_to projects_path
    else
      @project = Project.find(@stage.project_id)
      @tasks = Task.where(:stage_id => @stage)
      @task_attachments = TaskAttachment.where(:company_id => current_user.company).where(:stage_id => @stage)
    end
  end

  def edit
    @stage = get_stage_permissions(params[:id])
    if @stage.nil?
      redirect_to stages_path
    else
      @stages = get_stages(@stage.project)
    end
  end

  def update
    @stage = get_stage_permissions(params[:id])
    if @stage.nil?
      redirect_to stages_path
    else
      @stage.update_attributes(params[:stage])
      save_groups(params[:group_ids],@stage)
      redirect_to stage_path(@stage)
    end
  end

  def destroy
    @stage = get_stage_permissions(params[:id])
    if @stage.nil?
      redirect_to stages_path
    else
      Permission.delete_all(:stage_id => @stage)
      @stage.destroy
      redirect_to stages_path
    end
  end


  protected

  def get_projects ()
    @users_projects =[]
    @company_perms = Permission.where(:company_id => current_user.company).where('project_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == current_user.group) && (company_perm.company == current_user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == current_user.company)))
        @users_projects << Project.find(company_perm.project_id)
      end
    end
    @users_projects
  end

  def get_stages (project_id)
    @users_stages =[]
    @company_perms = Permission.where(:company_id => current_user.company).where(:project_id => project_id).where('stage_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == current_user.group) && (company_perm.company == current_user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == current_user.company)))
        @users_stages << Stage.find(company_perm.stage_id)
      end
    end
    @users_stages
  end

  def get_stage_permissions(stage_id)
    @stage = nil
    @stage_perms = Permission.where(:company_id => current_user.company).where(:stage_id => stage_id).order(:group_id)
    @stage_perms.each do |stage_perm|
      if ((stage_perm.user == current_user) ||
         ((stage_perm.group == current_user.group) && (stage_perm.company == current_user.company)) ||
         ((stage_perm.group.nil?) && (stage_perm.user.nil?) && (stage_perm.company == current_user.company)))
        @stage = Stage.find(stage_id)
        @permissions = Permission.where(:stage_id => @stage)
      end
    end
    @stage
  end

  def need_saving?(new_group, stage_id)
    @need_to_save = true
    if (new_group.nil?)
      if (!Permission.where(:user_id => current_user).where(:stage_id => stage_id).empty?)
        @need_to_save = false
      end
    else
      if (new_group.to_i == 0)
        if (!Permission.where(:company_id => current_user.company).where(:stage_id => stage_id).empty?)
          @need_to_save = false
        end
      else
        if (!Permission.where(:group_id => new_group).where(:stage_id => stage_id).empty?)
          @need_to_save = false
        end
      end
    end
    @need_to_save
  end

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

  def save_groups(groups, stage)
    Permission.delete_all(:stage_id => stage)
    if (groups.nil?)
      if (need_saving?(nil,stage.id))
        @new_permission = Permission.new
        @new_permission.stage = stage
        @new_permission.company = current_user.company
        @new_permission.user = current_user
        @new_permission.save
      end
    else
      groups.each do |new_group|
        while (!new_group.nil?)
          if need_saving?(new_group,stage.id)
            @new_permission = Permission.new
            @new_permission.stage = stage
            @new_permission.company = current_user.company
            if (new_group.to_i != 0)
              @new_permission.group = Group.find(new_group)
            end
            @new_permission.save
          end
          if (new_group.to_i != 0)
            new_group = Group.find(new_group).parent_id
          else
            new_group = nil
          end
        end
      end
    end
  end
end
