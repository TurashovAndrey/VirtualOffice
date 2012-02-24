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
      html = %(<a href="#{edit_event_path(event.id)}" title="#{h(event.name)}">)
      #html = %(<a href="#{edit_event_path(event.id)}" title="#{h(event.name)}">#{h(event.name)}"</a>)
      html<<%(<span class="ec-event-time">#{h(event.user.email)}</span>)
      html<<%(#{h(event.name)}</a>)
      html
    end
  end
end
