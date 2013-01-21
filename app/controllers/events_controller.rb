# coding: utf-8
class EventsController < ApplicationController
  def create
    @event = Event.new
    @event.user = current_user
    @calendar = Calendar.find(params[:event][:calendar_id])
    if @event.update_attributes(params[:event])
      flash[:notice] = t('event.flashes.saves')
    else
      flash[:error] = t('event.flashes.save_error')
    end
    redirect_to calendar_path(@calendar)
  end

  def destroy
    @event = Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to calendars_path, :error => t('event.flashes.delete_error')
    else
      @calendar = Calendar.find(params[:event][:calendar_id])
      if @event.destroy
        flash[:notice] = t('event.flashes.deleted')
      else
        flash[:error] = t('event.flashes.delete_error')
      end
      redirect_to calendar_path(@calendar)
  end

  def update
    @event = Event.find(params[:id])
    if !@event.nil?
      if @event.update_attributes(params[:event])
        flash[:notice] = t('event.flashes.saves')
      else
        flash[:error] = t('event.flashes.save_error')
      end
      redirect_to calendar_path(@calendar)
    else
      redirect_to calendars_path
    end
  end
end
