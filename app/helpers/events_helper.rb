# coding: utf-8
module EventsHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month),
      :first_day_of_week => @first_day_of_week
    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event = args[:event]
      @start_date = event.start_at.to_date
      @end_date = event.end_at.to_date

      if event.start_at.hour<10
        @start_time = "0"+event.start_at.hour.to_s
      else
        @start_time = event.start_at.hour.to_s
      end
      @start_time += ":"

      if event.start_at.min<10
        @start_time += "0"+event.start_at.min.to_s
      else
        @start_time += event.start_at.min.to_s
      end

      if event.end_at.hour<10
        @end_time = "0"+event.end_at.hour.to_s
      else
        @end_time = event.end_at.hour.to_s
      end
      @end_time += ":"

      if event.end_at.min<10
        @end_time += "0"+event.end_at.min.to_s
      else
        @end_time += event.end_at.min.to_s
      end

      #html = %(<span href="#">#{h(event.name)}</span>)
      title = "Название:"+event.name+"<br/>"+
              "Описание:"+event.description+"<br/>"+
              "Начало:"+@start_date.to_s+"<br/>"+
              "Время:"+@start_time+"<br/>"+
              "Окончание:"+@end_date.to_s+"<br/>"+
              "Время:"+@end_time
      html = %(<div class="tTip" id=#{h(event.name)} title=#{h(title)}><a href="#{calendars_path(:event_id => event.id)}" style="padding:0; color:white">#{h(event.name)}</a></div> )
      html
    end
  end
end
