class CalendarsController < ApplicationController
  def show
    @calendar = get_calendar_permissions(params[:id])
    if @calendar.nil?
      redirect_to calendars_path
    else
      @all_calendars = CalendarsHelper.get_calendars(current_user)
      @all_calendars += CalendarsHelper.get_private_calendars(current_user)

      @company_calendars = CalendarsHelper.get_calendars(current_user)
      @my_calendars = CalendarsHelper.get_private_calendars(current_user)

      @event = Event.new
      @event.user = current_user
      @event.calendar = @calendar
      load_calendar(@calendar)
    end
  end

  def index
    @company_calendars = CalendarsHelper.get_calendars(current_user)
    @my_calendars = CalendarsHelper.get_private_calendars(current_user)
    @all_calendars = CalendarsHelper.get_calendars(current_user)
    @all_calendars += CalendarsHelper.get_private_calendars(current_user)

    @new_calendar = Calendar.new

    if (params[:calendar_id].nil?) && (!@company_calendars.nil?)
      @calendar = Calendar.find(current_user.company.calendar_id)
    else
      @calendar = Calendar.find(params[:calendar_id])
    end

    if (params[:event_id].nil?)
        @event = Event.new
        @event.user = current_user
        @event.calendar = @calendar
    else
        @event = Event.find(params[:event_id])
    end

    if !@calendar.nil?
      load_calendar(@calendar)
    end
  end

  def edit
    @calendar = get_calendar_permissions(params[:id])
    @new_calendar = Calendar.new
    if @calendar.nil?
      redirect_to calendars_path
    else
      @company_calendars = CalendarsHelper.get_calendars(current_user)
      @my_calendars = CalendarsHelper.get_private_calendars(current_user)
    end
  end

  def update
    @calendar = get_calendar_permissions(params[:id])
    if @calendar.nil?
      redirect_to calendars_path
    else
      @calendar = Calendar.find(params[:id])
      @calendar.update_attributes(params[:calendar])
      if (!params[:group_ids].nil?)
        save_groups(params[:group_ids],@calendar)
      end
      respond_to do |format|
        format.html  {redirect_to calendar_path(@calendar)}
        format.json { render :json => @calendar, :status => :ok }
      end
    end
  end

  def new
    @calendar = Calendar.new
    @new_calendar = Calendar.new
    @company_calendars = CalendarsHelper.get_calendars(current_user)
    @my_calendars = CalendarsHelper.get_private_calendars(current_user)
  end

  def create
    if (params[:calendar][:calendar_name].empty?)
      redirect_to calendars_path
    else
      @calendar = Calendar.new
      @calendar.user = current_user
      @calendar.company = current_user.company
      @calendar.update_attributes(params[:calendar])

      save_groups(params[:group_ids],@calendar)
      redirect_to calendars_path
    end
  end

  def destroy
    if (current_user.company.calendar_id == params[:id].to_i)
      redirect_to :action => "index"
    else
      @calendar = get_calendar_permissions(params[:id])
      if !@calendar.nil?
        Permission.delete_all(:calendar_id => @calendar)
        @calendar.destroy
      end
      redirect_to :action => "index"
    end
  end
  protected

  def load_calendar(calendar)
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @event_strips = calendar.events.event_strips_for_month(@shown_month, @first_day_of_week)
  end

  def get_calendar_permissions(calendar_id)
    @calendar = nil
    @calendar_perms = Permission.where(:company_id => current_user.company).where(:calendar_id => calendar_id).order(:group_id)
    @calendar_perms.each do |calendar_perm|
      if ((calendar_perm.user == current_user) ||
         ((calendar_perm.group == current_user.group) && (calendar_perm.company == current_user.company)) ||
         ((calendar_perm.group.nil?) && (calendar_perm.user.nil?) && (calendar_perm.company == current_user.company)))
         @calendar = Calendar.find(calendar_id)
         @permissions = Permission.where(:calendar_id => @calendar)
      end
    end
    @calendar
  end

   def need_saving?(new_group, calendar_id)
      @need_to_save = true
      if (new_group.nil?)
        if (!Permission.where(:user_id => current_user).where(:calendar_id => calendar_id).empty?)
          @need_to_save = false
        end
      else
        if (new_group.to_i == 0)
          if (!Permission.where(:company_id => current_user.company).where(:calendar_id => calendar_id).empty?)
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

    def save_groups(groups, calendar)
      @need_save = true
      Permission.delete_all(:calendar_id => calendar)
      if (groups.nil?)
        if (need_saving?(nil,calendar.id))
          @new_permission = Permission.new
          @new_permission.calendar = calendar
          @new_permission.company = current_user.company
          @new_permission.user = current_user
          @new_permission.save
        end
      else
        groups.each do |new_group|
          while (!new_group.nil?) && (@need_save)
            if need_saving?(new_group,calendar.id)
              @new_permission = Permission.new
              @new_permission.calendar = calendar
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
