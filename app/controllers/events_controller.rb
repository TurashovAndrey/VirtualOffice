# coding: utf-8
class EventsController < ApplicationController
  def index
    redirect_to calendars_path
  end

  def new
    @event.user = current_user
    @event.company = current_user.company
  end

  def create
    @event = Event.new
    @event.user = current_user
    @event.calendar = Calendar.find(params[:event][:calendar_id])
    @event.update_attributes(params[:event])
    redirect_to calendars_path
  end

  def destroy
    if @event.destroy
      flash[:notice] = t('event.flashes.deleted')
    else
      flash[:error] = t('event.flashes.delete_error')
    end
    redirect_to events_path
  end

  def edit
    load_calendar
    render 'index'
  end

  def update
    if (params[:event][:color] == 'Очень важно')
      @event.update_attribute("color","#FF0000")
    end
    if (params[:event][:color] == 'Важно')
      @event.update_attribute("color","#FFFF00")
    end
    if (params[:event][:color] == 'Не важно')
      @event.update_attribute("color","#00FF00")
    end

    if @event.update_attributes(params[:event])
      flash[:notice] = t('event.flashes.saves')
    else
      flash[:error] = t('event.flashes.save_error')
    end
    redirect_to events_path
  end

  protected

  def get_calendars ()
      @users_calendars =[]
      @company_perms = Permission.where(:company_id => current_user.company).where(!:calendar_id.nil?).order(:group_id)
      @company_perms.each do |company_perm|
        if (((company_perm.group == current_user.group) && (company_perm.company == current_user.company)) ||
           ((company_perm.group.nil?) && (company_perm.user.nil?)  && (company_perm.company == current_user.company)))
          @users_calendars << Calendar.find(company_perm.calendar_id)
        end
      end
      @users_calendars
  end

  def get_private_calendars ()
      @private_calendars = []
      @private_perms = Permission.where(:user_id => current_user).where(!:calendar_id.nil?)
      @private_perms.each do |private_perm|
        @private_calendars << Calendar.find(private_perm.calendar_id)
      end
      @private_calendars
  end

  def load_calendar(calendar)
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @event_strips = calendar.events.event_strips_for_month(@shown_month, @first_day_of_week)
  end
end
