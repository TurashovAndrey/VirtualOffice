# coding: utf-8
class AllTasksGrid < Netzke::Basepack::GridPanel
  def configuration
    super.merge({
      :model => "Task",
      :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
      :height => 400,
      # Declaring columns
      :columns => [
        {
          :name => :done,
          :header => 'Выполнено',
          :width => 70,
          :default_value => false
        },
        {
          :name => :title,
          :header =>'Название',
          :width => 250
        },
        {
          :name => :notes,
          :header => 'Комментарии',
          :width => 200
        },
        {
          :name => :priority,
          :header => 'Приоритет',
          :width => 70
        },
        {
          :name => :due,
          :header => 'Дата окончания'
        },
        {
          :name => :user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :header => "Сотрудник 1",
          :default_value => User.find(Netzke::Core::session[:netzke_user_id]).id,
          :width => 150
        },
        {
          :name => :second_user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :header => "Сотрудник 2",
          :width => 150
        },
        {
          :name => :company__url_base,
          :default_value => Company.find(User.find(Netzke::Core::session[:netzke_user_id]).company_id).id,
          :header => "Компания",
          :read_only => true,
          :width => 150
        }
      ]
    })
  end
end