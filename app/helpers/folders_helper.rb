module FoldersHelper
  def self.get_folders (user)
    @users_folders =[]
    @all_folders = []
    @company_perms = Permission.where(:company_id => user.company).where('folder_id != ""').order(:group_id)
    @company_perms.each do |company_perm|
      if (((company_perm.group == user.group) && (company_perm.company == user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == user.company)))
        @users_folders << Folder.find(company_perm.folder_id)
        @all_folders << Folder.find(company_perm.folder_id)
      end
    end
    @users_folders
  end

  def self.get_private_folders (user)
    @private_folders = []
    @private_perms = Permission.where(:user_id => user).where('folder_id IS NOT NULL').all
    @private_perms.each do |private_perm|
      @private_folders << Folder.find(private_perm.folder_id)
      @all_folders << Folder.find(private_perm.folder_id)
    end
    @private_folders
  end


  def self.get_folder_permissions(folder_id,user)
    @folder = nil
    @folder_perms = Permission.where(:company_id => user.company).where(:folder_id => folder_id).order(:group_id)
    @folder_perms.each do |folder_perm|
      if ((folder_perm.user == user) ||
         ((folder_perm.group == user.group) && (folder_perm.company == user.company)) ||
         ((folder_perm.group.nil?) && (folder_perm.user.nil?) && (folder_perm.company == user.company)))
        @folder = Folder.find(folder_id)
        @permissions = Permission.where(:folder_id => @folder)
      end
    end
    @folder
  end

  def self.need_saving?(new_group, folder_id,user)
    @need_to_save = true
    if (new_group.nil?)
      if (!Permission.where(:user_id => user).where(:folder_id => folder_id).empty?)
        @need_to_save = false
      end
    else
      if (new_group.to_i == 0)
        if (!Permission.where(:company_id => user.company).where(:folder_id => folder_id).empty?)
          @need_to_save = false
        end
      else
        if (!Permission.where(:group_id => new_group).where(:folder_id => folder_id).empty?)
          @need_to_save = false
        end
      end
    end
    @need_to_save
  end

  def self.save_groups(groups, folder,user)
    Permission.delete_all(:folder_id => folder)
    if (groups.nil?)
      if (self.need_saving?(nil,folder.id,user))
        @new_permission = Permission.new
        @new_permission.folder = folder
        @new_permission.company = user.company
        @new_permission.user = user
        @new_permission.save
      end
    else
      groups.each do |new_group|
        while (!new_group.nil?)
          if self.need_saving?(new_group,folder.id,user)
            @new_permission = Permission.new
            @new_permission.folder = folder
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
