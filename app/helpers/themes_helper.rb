module ThemesHelper
  def self.get_themes (user)
    @users_themes =[]
    @company_perms = Permission.where(:company_id => user.company).where('theme_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == user.group) && (company_perm.company == user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == user.company)))
        @users_themes << Theme.find(company_perm.theme_id)
      end
    end
    @users_themes
  end

  def self.get_theme_permissions(theme_id,user)
    @theme = nil
    @theme_perms = Permission.where(:company_id => user.company).where(:theme_id => theme_id).order(:group_id)
    @theme_perms.each do |theme_perm|
      if ((theme_perm.user == user) ||
         ((theme_perm.group == user.group) && (theme_perm.company == user.company)) ||
         ((theme_perm.group.nil?) && (theme_perm.user.nil?) && (theme_perm.company == user.company)))
        @theme = Theme.find(theme_id)
        @permissions = Permission.where(:theme_id => @theme)
      end
    end
    @theme
  end

  def self.need_saving?(new_group, theme_id, user)
    @need_to_save = true
    if (new_group.nil?)
      if (!Permission.where(:user_id => user).where(:theme_id => theme_id).empty?)
        @need_to_save = false
      end
    else
      if (new_group.to_i == 0)
        if (!Permission.where(:company_id => user.company).where(:theme_id => theme_id).empty?)
          @need_to_save = false
        end
      else
        if (!Permission.where(:group_id => new_group).where(:theme_id => theme_id).empty?)
          @need_to_save = false
        end
      end
    end
    @need_to_save
  end

  def self.save_groups(groups, theme, user)
    Permission.delete_all(:theme_id => theme)
    if (groups.nil?)
      if (self.need_saving?(nil,theme.id,user))
        @new_permission = Permission.new
        @new_permission.theme = theme
        @new_permission.company = user.company
        @new_permission.user = user
        @new_permission.save
      end
    else
      groups.each do |new_group|
        while (!new_group.nil?)
          if self.need_saving?(new_group,theme.id,user)
            @new_permission = Permission.new
            @new_permission.theme = theme
            @new_permission.company = user.company
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
