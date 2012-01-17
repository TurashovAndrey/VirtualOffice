class DelegateTasksGrid < Netzke::Basepack::GridPanel
  def configuration
    super.merge({
      :model => "Task",
      :scope => {:second_user_id => Netzke::Core::session[:netzke_user_id]},
      :height => 400,
      # Declaring columns
      :columns => [
        :done,
        :title,
        :notes,
        :priority,
        :due,
        {
          :name => :user__email,
          :header => "User"
        },
        {
          :name => :second_user__email,
          :header => "Second User"
        }
      ]
    })
  end
end