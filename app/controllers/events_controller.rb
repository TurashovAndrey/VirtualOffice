class EventsController < ApplicationController
  filter_resource_access :additional_new => :index

  def index
    load_calendar
  end

  def create
    @event.user = current_user
    @event.company = current_user.company

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
