# coding: utf-8
class EventsController < ApplicationController
  filter_resource_access :additional_new => :index

  def index
    load_calendar
  end

  def new
    @event.user = current_user
    @event.company = current_user.company
  end

  def create
    @event.user = current_user
    @event.company = current_user.company

    if (params[:event][:color] == 'Красный')
      @event.update_attribute("color","#FF0000")
    end
    if (params[:event][:color] == 'Зеленый')
      @event.update_attribute("color","#00FF00")
    end
    if (params[:event][:color] == 'Синий')
      @event.update_attribute("color","#0000FF")
    end

    @event.update_attribute("start_at", params[:event][:start_at])
    @event.update_attribute("end_at", params[:event][:end_at])

    if @event.save
      flash[:notice] = t('event.flashes.created')
    else
      flash[:error] = t('event.flashes.create_error')
    end
    redirect_to events_path
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
    if (params[:event][:color] == 'Красный')
      @event.update_attribute("color","#FF0000")
    end
    if (params[:event][:color] == 'Зеленый')
      @event.update_attribute("color","#00FF00")
    end
    if (params[:event][:color] == 'Синий')
      @event.update_attribute("color","#0000FF")
    end

    if @event.update_attributes(params[:event])
      flash[:notice] = t('event.flashes.saves')
    else
      flash[:error] = t('event.flashes.save_error')
    end
    redirect_to events_path
  end

  protected

  def load_calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @event_strips = current_user.company.events.event_strips_for_month(@shown_month, @first_day_of_week)
  end
end
