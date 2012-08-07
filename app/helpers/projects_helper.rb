module ProjectsHelper
  def self.get_projects (user)
    @users_projects =[]
    @company_perms = Permission.where(:company_id => user.company).where('project_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == user.group) && (company_perm.company == user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == user.company)))
        @users_projects << Project.find(company_perm.project_id)
      end
    end
    @users_projects
  end

  def self.get_stages (project_id, user)
    @users_stages =[]
    @company_perms = Permission.where(:company_id => user.company).where(:project_id => project_id).where('stage_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == user.group) && (company_perm.company == user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == user.company)))
        @users_stages << Stage.find(company_perm.stage_id)
      end
    end
    @users_stages
  end
end
