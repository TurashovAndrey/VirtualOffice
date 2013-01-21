class CalendarsController < ApplicationController
  def index
    get_init_calendars
    @new_calendar = Calendar.new
    unless current_user.company.calendars.first.nil?
      @default_calendar = current_user.company.calendars.first
      @event = Event.new
      @event.calendar = @default_calendar
      load_calendar(@default_calendar)
    end
  end

  def show
    @calendar = Calendar.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_show')
    else
      get_init_calendars
      @new_calendar = Calendar.new
      if has_permission_to_calendar? params[:id]
        @event = Event.new
        @event.calendar = @calendar
        load_calendar(@calendar)
      else
        redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_show')
      end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_edit')
    else
      if has_permission_to_calendar? params[:id]
        get_init_calendars
      else
        redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_edit')
      end
  end

  def update
    @calendar = Calendar.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_edit')
    else
      if has_permission_to_calendar? params[:id]
        if @calendar.update_attributes(params[:calendar])
          redirect_to calendar_url(@calendar), :notice => t('calendar.save.success')
        else
          redirect_to calendars_url, :error => t('calendar.save.error')
        end
      else
        redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_edit')
      end
  end

  def new
    redirect_to calendars_path
  end

  def create
    @calendar = Calendar.new
    @calendar.user = current_user
    @calendar.company = current_user.company
    if @calendar.update_attributes(params[:calendar])
      redirect_to calendars_url, :notice => t('calendar.save.success')
    else
      redirect_to calendar_url(@calendar),:error => t('calendar.save.error')
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to calendars_url, :error => t('calendar.flash.has_no_permission_to_edit')
    else
    if has_permission_to_calendar?(params[:id])
       @calendar.destroy
    else
      flash[:error] = t('calendar.flash.has_no_permission_to_delete')
    end
    redirect_to calendars_url, :notice => t('calendar.delete.success')
  end

  protected

  def has_permission_to_calendar?(calendar_id)
    (Calendar.find(calendar_id).company == current_user.company) or
        (Calendar.find(calendar_id).user == current_user)
  end

  def get_init_calendars
    @company_calendars = current_user.company.calendars
  end

  def load_calendar(calendar)
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @event_strips = calendar.events.event_strips_for_month(@shown_month, @first_day_of_week)
  end
end
