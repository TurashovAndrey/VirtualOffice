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
          :name => :id,
          :header => 'Id',
          :width => 70,
          :hidden => false
        },
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
      ],
      :edit_form_window_config => {
          :title => 'Редактировать задание',
      },
      :add_form_window_config => {
          :title => 'Добавить задание'
      },
      :edit_form_config => {
          :height => 300,
          :model => "Task",
          :items => [
        {
          :name => :id,
          :field_label => 'Id',
          :width => 70,
          :hidden => false,
          :read_only => true
        },
        {
          :name => :done,
          :field_label => 'Выполнено',
          :width => 70,
          :default_value => false
        },
        {
          :name => :title,
          :field_label =>'Название',
          :width => 250
        },
        {
          :name => :notes,
          :field_label => 'Комментарии',
          :width => 200
        },
        {
          :name => :priority,
          :field_label => 'Приоритет',
          :width => 70
        },
        {
          :name => :due,
          :field_label => 'Дата окончания'
        },
        {
          :name => :user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :field_label => "Сотрудник 1",
          :default_value => User.find(Netzke::Core::session[:netzke_user_id]).id,
          :width => 150
        },
        {
          :name => :second_user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :field_label => "Сотрудник 2",
          :width => 150
        },
        {
          :name => :company__url_base,
          :default_value => Company.find(User.find(Netzke::Core::session[:netzke_user_id]).company_id).id,
          :field_label => "Компания",
          :read_only => true,
          :width => 150
        }
        ]},
        :add_form_config => {
          :height => 300,
          :model => "Task",
          :items => [
        {
          :name => :id,
          :field_label => 'Id',
          :width => 70,
          :hidden => false,
          :read_only => true
        },
        {
          :name => :done,
          :field_label => 'Выполнено',
          :width => 70,
          :default_value => false
        },
        {
          :name => :title,
          :field_label =>'Название',
          :width => 250
        },
        {
          :name => :notes,
          :field_label => 'Комментарии',
          :width => 200
        },
        {
          :name => :priority,
          :field_label => 'Приоритет',
          :width => 70
        },
        {
          :name => :due,
          :field_label => 'Дата окончания'
        },
        {
          :name => :user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :field_label => "Сотрудник 1",
          :default_value => User.find(Netzke::Core::session[:netzke_user_id]).id,
          :width => 150
        },
        {
          :name => :second_user__email,
          :scope => {:company_id => User.find(Netzke::Core::session[:netzke_user_id]).company_id},
          :field_label => "Сотрудник 2",
          :width => 150
        },
        {
          :name => :company__url_base,
          :default_value => Company.find(User.find(Netzke::Core::session[:netzke_user_id]).company_id).id,
          :field_label => "Компания",
          :read_only => true,
          :width => 150
        }
        ]}
    })
  end
end