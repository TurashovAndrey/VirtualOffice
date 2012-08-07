module CalendarsHelper
  def self.get_calendars (user)
    @all_calendars = []
    @users_calendars =[]
    @company_perms = Permission.where(:company_id => user.company).where('calendar_id != ""').order(:group_id).all
    @company_perms.each do |company_perm|
      if (((company_perm.group == user.group) && (company_perm.company == user.company)) ||
         ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == user.company)))
        @users_calendars << Calendar.find(company_perm.calendar_id)
        @all_calendars << Calendar.find(company_perm.calendar_id)
      end
    end
    @users_calendars
  end

  def self.get_private_calendars (user)
    @private_calendars = []
    @private_perms = Permission.where(:user_id => user).where('calendar_id IS NOT NULL')
    @private_perms.each do |private_perm|
      @private_calendars << Calendar.find(private_perm.calendar_id)
      @all_calendars << Calendar.find(private_perm.calendar_id)
    end
    @private_calendars
  end

  def self.get_calendar_permissions(calendar_id,user)
    @calendar = nil
    @calendar_perms = Permission.where(:company_id => user.company).where(:calendar_id => calendar_id).order(:group_id)
    @calendar_perms.each do |calendar_perm|
      if ((calendar_perm.user == user) ||
         ((calendar_perm.group == user.group) && (calendar_perm.company == user.company)) ||
         ((calendar_perm.group.nil?) && (calendar_perm.user.nil?) && (calendar_perm.company == user.company)))
         @calendar = Calendar.find(calendar_id)
         @permissions = Permission.where(:calendar_id => @calendar)
      end
    end
    @calendar
  end

   def need_saving?(new_group, calendar_id,user)
      @need_to_save = true
      if (new_group.nil?)
        if (!Permission.where(:user_id => user).where(:calendar_id => calendar_id).empty?)
          @need_to_save = false
        end
      else
        if (new_group.to_i == 0)
          if (!Permission.where(:company_id => user.company).where(:calendar_id => calendar_id).empty?)
            @need_to_save = false
          end
        else
          if (!Permission.where(:group_id => new_group).where(:calendar_id => calendar_id).empty?)
            @need_to_save = false
          end
        end
      end
      @need_to_save
    end

    def self.save_groups(groups, calendar,user)
      Permission.delete_all(:calendar_id => calendar)
      if (groups.nil?)
        if (need_saving?(nil,calendar.id,user))
          @new_permission = Permission.new
          @new_permission.calendar = calendar
          @new_permission.company = user.company
          @new_permission.user = user
          @new_permission.save
        end
      else
        groups.each do |new_group|
          while (!new_group.nil?)
            if need_saving?(new_group,calendar.id,user)
              @new_permission = Permission.new
              @new_permission.calendar = calendar
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