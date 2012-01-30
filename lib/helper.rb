# coding: utf-8
module Helper
  require 'envolve_chat'

  def self.get_chat_script(user)

    if (user!=nil)
      @firstname = user.first_name=="" ? user.email: user.first_name
      @envolve_html_code = EnvolveChat::ChatRenderer.get_html("50879-2vO9DDq6kmqbiIViHl2rntDi9mFADrIY",
      {
        :first_name => @firstname,
        :last_name => user.last_name,
        :is_admin => false,
        :groups => [{:id => user.company.url_base, :name => user.company.name},{:id => "Default", :name => "Default chat"}],
        :strings => "TurnOff : 'Выключить',TurnOnTooltip:'Включить',Sound:'Звук',LogOutTitleText:'Выйти',LoggingOut:'Выйти из чата'"
      })
    else
      @envolve_html_code = EnvolveChat::ChatRenderer.get_html("50879-2vO9DDq6kmqbiIViHl2rntDi9mFADrIY",
      {
        :is_admin => false,
        :strings => "TurnOff : 'Выключить',TurnOnTooltip:'Включить',Sound:'Звук',LogOutTitleText:'Выйти',LoggingOut:'Выйти из чата'"
      })
    end

    @envolve_html_code
  end
end