# coding: utf-8
class EventsController < ApplicationController
  def index
    redirect_to calendars_path
  end

  def new
    redirect_to calendars_path
  end

  def create
    if (params[:event][:name].empty?)
      redirect_to calendars_path
    else
      @event = Event.new
      @event.user = current_user
      @calendar = get_calendar_permissions(params[:event][:calendar_id])
      if !@calendar.nil?
        if @event.update_attributes(params[:event])
          flash[:notice] = t('event.flashes.saves')
        else
          flash[:error] = t('event.flashes.save_error')
        end
        redirect_to calendars_path(:calendar_id => @calendar)
      else
        redirect_to calendars_path
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if !@event.nil?
      @calendar = get_calendar_permissions(@event.calendar_id)
      if !@calendar.nil?
        if @event.destroy
          flash[:notice] = t('event.flashes.deleted')
        else
          flash[:error] = t('event.flashes.delete_error')
        end
        redirect_to calendar_path(@calendar)
      else
        redirect_to calendars_path
      end
    else
      redirect_to calendars_path
    end
  end

  def edit
    redirect_to calendars_path
  end

  def update
    @event = Event.find(params[:id])
    if !@event.nil?
      @calendar = get_calendar_permissions(@event.calendar_id)
      if !@calendar.nil?
        if @event.update_attributes(params[:event])
          flash[:notice] = t('event.flashes.saves')
        else
          flash[:error] = t('event.flashes.save_error')
        end
        redirect_to calendar_path(@calendar)
      else
        redirect_to calendars_path
      end
    else
      redirect_to calendars_path
    end
  end

  protected

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

end
